//
//  ChatViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 19/04/2023.
//

import UIKit
import Firebase
import FirebaseCore

class ChatViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var bg: UIImageView!
    
    @IBOutlet weak var messageTF: UITextField!
    

    var chatViewModel : ChatViewModel?
    var menuDelegate : ChatControllerDelegate?
    var menu : UIMenu?
    var userName : String?
    var friend : User?
    var privateRoomsArr : [PrivateRoom]?
    var messagesArr : [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderTableViewCell")
        tableView.register(UINib(nibName: "RecieverTableViewCell", bundle: nil), forCellReuseIdentifier: "RecieverTableViewCell")
        
        chatViewModel = ChatViewModel(viewModelDelegate: self, navigator: self)
        chatViewModel?.chatUI = (messageTF , tableView)
        chatViewModel?.configureUI()
        chatViewModel?.getAllPrivateRoomFromDB()
        chatViewModel?.bindingRooms = {[weak self]rooms in
            self?.privateRoomsArr = rooms
            for room in self?.privateRoomsArr ?? [] {
                if (room.senderID == UserProvider.getInstance.getCurrentUser()?.id
                    || room.senderID == self?.friend?.id)
                    && (room.recieverID == self?.friend?.id || room.recieverID == UserProvider.getInstance.getCurrentUser()?.id)
                {
                    self?.chatViewModel?.getAllMessagesFromDB(roomID: room.id ?? "")
                    break;
                }
            }
        }
        
        
        chatViewModel?.bindingMessages = {[weak self]messages in
            self?.messagesArr = messages
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                guard let messages = self?.messagesArr else { return }
                if !messages.isEmpty {
                    self?.tableView.scrollToRow(at: IndexPath(row: (self?.messagesArr?.count ?? 0)-1, section: 0), at: .bottom, animated: true)
                }
            }
        }
//        print(messagesArr?.first?.content)
        var menuActions : [UIAction] = []
        
        _ = chatViewModel?.menuItems.map{ menuitem in
            let menuAction = UIAction(title:menuitem.title ?? "" , image: menuitem.image) { action in
                menuitem.MenuItemAction()
            }
            menuActions.append(menuAction)
        }
        
        menu = UIMenu(options: UIMenu.Options.displayInline , children: menuActions)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.titleView = chatViewModel?.navTitleWithImageAndText(titleText: friend?.userName ?? "errorNoName", imageName: friend?.imageRef ?? "errorNoImage")
        let button1 = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle") )// action:#selector(Class.MethodName) for swift 3
        button1.menu = menu
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    @IBAction func onSendBtn(_ sender: UIButton) {
        
        guard let friend = friend , let user = UserProvider.getInstance.getCurrentUser() else {
            print("error : NoFriend or NoUserLoggedIn")
            return
        }
//        print(privateRoomsArr?.first?.id)
        chatViewModel?.addMessageToDB(from: user, to: friend, rooms: privateRoomsArr)
        
        

    }

}
extension ChatViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messagesArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if messagesArr?[indexPath.row].senderId == UserProvider.getInstance.getCurrentUser()?.id {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell", for: indexPath) as! SenderTableViewCell
            
            cell.senderName.text = messagesArr?[indexPath.row].senderName
            cell.messageContent.text =  messagesArr?[indexPath.row].content
            cell.messageDate.text = messagesArr?[indexPath.row].dateTime
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverTableViewCell", for: indexPath) as! RecieverTableViewCell
        
        cell.recieverName.text = messagesArr?[indexPath.row].senderName
        cell.messageContent.text = messagesArr?[indexPath.row].content
        cell.messageDate.text = messagesArr?[indexPath.row].dateTime
        
        return cell
    }
    
    
}
extension ChatViewController : UITableViewDelegate
{
    
}

extension ChatViewController : ChatViewModelDelegate {
    func onRemoveFriendSelected() {
//        menuDelegate?.removeFriendSelected()
        print("onRemoveFriendSelected")
    }
    
    func onAboutFriendSelected() {
//        menuDelegate?.aboutFriendSelected()
        print("onAboutFriendSeleted")
        let friendDetailsVC = FriendDetailsViewController(nibName: "FriendDetailsViewController", bundle: nil)
        friendDetailsVC.friend = friend
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(friendDetailsVC, animated: true)
        }else{
            self.navigationController?.pushViewController(friendDetailsVC, animated: true)
        }
        
        
    }
    
    
}

