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
    var menuDelegate : ReloadTableView?
//    var roomDelegate : ConversationStatus?
//    var reload : ReloadGroupsDelegate?
    var menu : UIMenu?
    var userName : String?
    var friend : User?
    var group : Group?
//    var currentRoom : PrivateRoom?
    var privateRoomsArr : [PrivateRoom]?
    var messagesArr : [Message]?
    var groupMessagesArr : [GroupMessage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SenderTableViewCell", bundle: nil), forCellReuseIdentifier: "SenderTableViewCell")
        tableView.register(UINib(nibName: "RecieverTableViewCell", bundle: nil), forCellReuseIdentifier: "RecieverTableViewCell")
        if let group = group
        {
            chatViewModel = ChatViewModel(viewModelDelegate: self, navigator: self , group: group)
            chatViewModel?.getAllGroupMessageFromDB(group: group)
            chatViewModel?.bindingGroupMessages = {[weak self] messages in
                self?.groupMessagesArr = messages
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    guard let messages = self?.groupMessagesArr else { return }
                    if !messages.isEmpty {
                        self?.tableView.scrollToRow(at: IndexPath(row: (self?.groupMessagesArr?.count ?? 0)-1, section: 0), at: .bottom, animated: true)
                    }
                }
            }
        }else{
            chatViewModel = ChatViewModel(viewModelDelegate: self, navigator: self )
        }
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
                    self?.chatViewModel?.getAllMessagesFromDB(room : room)
//                    self?.currentRoom = room
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
        if let group = group{
            self.navigationItem.titleView = chatViewModel?.navTitleWithImageAndText(titleText: group.name ?? "errorNoGroupName", imageName: group.imageREF ?? "errorNoGroupImage")
        }else{
            self.navigationItem.titleView = chatViewModel?.navTitleWithImageAndText(titleText: friend?.userName ?? "errorNoName", imageName: friend?.imageRef ?? "errorNoImage")
        }
        
        let button1 = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle") )
        button1.menu = menu
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    @IBAction func onSendBtn(_ sender: UIButton) {
        
        guard let user = UserProvider.getInstance.getCurrentUser() else {
            print("error : NoUserLoggedIn")
            return
        }
//        print(privateRoomsArr?.first?.id)
        if let group = group
        {
            chatViewModel?.addMessageToDB(from: user, to: friend ?? User(), rooms: privateRoomsArr , group: group)
        }else{
            guard let friend = friend else{
                print("error : NoFriend ")
                return}
            chatViewModel?.addMessageToDB(from: user, to: friend, rooms: privateRoomsArr)
            // update
//            print(currentRoom?.id)
//            chatViewModel?.updatePrivateRoom(room: currentRoom!)
        }
        

    }

}
extension ChatViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var messagCount : Int = 0
        if let _ = group{
            messagCount = groupMessagesArr?.count ?? 0
        }else{
            messagCount = messagesArr?.count ?? 0
        }
        return messagCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if let _ = group {
            if groupMessagesArr?[indexPath.row].senderID == UserProvider.getInstance.getCurrentUser()?.id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell", for: indexPath) as! SenderTableViewCell
                
                cell.senderName.text = groupMessagesArr?[indexPath.row].senderName
                cell.messageContent.text =  groupMessagesArr?[indexPath.row].content
                cell.messageDate.text = groupMessagesArr?[indexPath.row].dateTime
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecieverTableViewCell", for: indexPath) as! RecieverTableViewCell
            
            cell.recieverName.text = groupMessagesArr?[indexPath.row].senderName
            cell.messageContent.text = groupMessagesArr?[indexPath.row].content
            cell.messageDate.text = groupMessagesArr?[indexPath.row].dateTime
            
            return cell
        }
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addFriendVC = segue.destination as! AddFriendViewController
        addFriendVC.group = sender as? Group
//        addFriendVC.reloadGroup = self
    }
    func onAddPeopleSelected() {
        print("onAddPeopleSlected")
        if UIDevice.current.userInterfaceIdiom == .phone{
            //present addFriendVC
            performSegue(withIdentifier: "GoToAddFriend", sender: group)
        }else{
            //push to addFriendVC
            let addFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
            addFriendVC.group = group
            self.navigationController?.pushViewController(addFriendVC, animated: true)
//            addFriendVC.reloadGroup = self
        }
    }
    
    func onRemoveFriendSelected() {
        
        guard let friend = friend else { return }
        print("onRemoveFriendSelected")
        if UIDevice.current.userInterfaceIdiom == .phone{
            //remove from db
            //pop to previous view
            //reload table ,--> this will done in will appear of homeVC
            
            chatViewModel?.remove(FriendFromDB: friend, onCompleteRemoveFriend: {
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            //remove from db
            //delegate to split and from split delegate to home
            //implement reload table by reload or fetch from db
            chatViewModel?.remove(FriendFromDB: friend, onCompleteRemoveFriend: { [weak self] in
                self?.menuDelegate?.reloadFriends()
            })
        }
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
//extension ChatViewController : ReloadGroups {
//    func getAllGroupChat() {
//        reload?.getAllGroupChatDelegate()
//    }
//}

