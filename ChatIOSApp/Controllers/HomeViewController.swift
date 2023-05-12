//
//  HomeViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 19/04/2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseStorageUI
class HomeViewController: BaseViewController {

    
    @IBOutlet weak var friendRequestBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var HomeMenuOptions: UIBarButtonItem!
    var homeViewModel : HomeViewModel?
    var delegate : HomeControllerDelegate?
    var menuDelegate : HomeControllerDelegate?
    var friendRequestDelegate : HomeControllerDelegate?
    var friendsArray : [User]?
    var requestsArr : [Request]?
    var groupsArr : [Group]?
//    var allPrivateRooms : [PrivateRoom]?
//    var roomsArr : [PrivateRoom] = []
    
    var data : Data?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "item")
        homeViewModel = HomeViewModel(viewModelNavigator: self)
        
        var menuActions : [UIAction] = []
        
        _ = homeViewModel?.menuItems.map{ menuItem in
            
            let menuAction = UIAction(title: menuItem.title ?? "",image: menuItem.image  ) { action in
                menuItem.MenuItemAction()
            }
            menuActions.append(menuAction)
        }
        
                let menu = UIMenu( options: .displayInline, children: menuActions)
        
        HomeMenuOptions.menu = menu
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.deselectRow(at: IndexPath(row: 0, section: 0), animated: true)
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "home".localized
        homeViewModel?.fetchAllFriendFromDB()
        
        homeViewModel?.bindingFriends = {[weak self] friends in
            self?.friendsArray = friends
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        homeViewModel?.fetchAllGroupChatFromDB()
        homeViewModel?.bindingAllGroupChat = {[weak self] groups in
            self?.groupsArr = groups
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        homeViewModel?.fetchAllFriendRequestFromDB()
        homeViewModel?.bindingAllRequest = {[weak self] requests in
            self?.requestsArr = requests
            DispatchQueue.main.async {
                guard let requestsArrCount = self?.requestsArr?.count else { return }
                self?.friendRequestBtn.setBadge(text: "\(requestsArrCount)" , withOffsetFromTopRight: CGPoint(x: 5, y: -0.7))
                if requestsArrCount == 0 {
                    self?.friendRequestBtn.removeBadge()
                }
            }
        }
//        homeViewModel?.getAllPrivateRoomFromDB()
//        homeViewModel?.bindingAllPrivateRooms = {[weak self] rooms in
//            self?.allPrivateRooms = rooms
//            for room in self?.allPrivateRooms ?? [] {
//                if (room.senderID == UserProvider.getInstance.getCurrentUser()?.id)
//                    || (room.recieverID == UserProvider.getInstance.getCurrentUser()?.id)
//                {
//                    self?.roomsArr.append(room)
//                }
//            }
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
        
    }


    @IBAction func onFriendRequestSelected(_ sender: UIBarButtonItem)
    {
        if UIDevice.current.userInterfaceIdiom == .pad{
            friendRequestDelegate?.FriendRequestSelected()
        }else{
            let friendRequestVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendRequestViewController") as! FriendRequestViewController
            
            self.navigationController?.pushViewController(friendRequestVC, animated: true)
        }
    }
}
extension HomeViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var arrCount = 0
        switch(section) {
        case 0:
            arrCount = friendsArray?.count ?? 0
        case 1:
            arrCount = groupsArr?.count ?? 0
        default:
            print("error in numberOfRowsInSection in HomeVC")
        }
        return arrCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! HomeTableViewCell
        switch(indexPath.section)
        {
        case 0:
            cell.userName.text = friendsArray?[indexPath.row].userName
            cell.userAbout.text = friendsArray?[indexPath.row].about
            if let imageREF = StorageUtils.sharedInstance.storageReference?.child(friendsArray?[indexPath.row].imageRef ?? "")  {
                cell.userImage.sd_setImage(with: imageREF, placeholderImage: UIImage(named: "1"))
            }else{
                print(" error in loading image in cell ")
            }
//            if roomsArr[indexPath.row].unreadMessages ?? 33 > 0{
//                cell.messageCount.text = String(roomsArr[indexPath.row].unreadMessages ?? 33)
//            }else{
//                //hide
//                cell.messageCount.isHidden = true
//            }
            cell.messageCount.isHidden = true
//            cell.messageCount.text = "999"
        case 1:
            cell.userName.text = groupsArr?[indexPath.row].name
            cell.userAbout.text = groupsArr?[indexPath.row].description
            if let imageREF = StorageUtils.sharedInstance.storageReference?.child(groupsArr?[indexPath.row].imageREF ?? "")  {
                cell.userImage.sd_setImage(with: imageREF, placeholderImage: UIImage(named: "1"))
            }else{
                print(" error in loading image in cell ")
            }
//            cell.messageCount.text = "23"
            cell.messageCount.isHidden = true
        default:
            print("error in cellForRowAt in HomeVC")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header = ""
        switch(section)
        {
        case 0:
            header = "friends"
        case 1:
            header = "groups"
        default:
            print("error in titleForHeaderINSection in HomeVC")
        }
        return header
    }
}
extension HomeViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath(row: indexPath.row, section: 0), animated: true)
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            switch(indexPath.section)
            {
            case 0:
                guard let friend = friendsArray?[indexPath.row] else {
                    return
                }
                delegate?.didTapItem(index: indexPath.row , friend: friend)
            case 1:
                guard let group = groupsArr?[indexPath.row] else {
                    return
                }
                delegate?.didTapItem(index: indexPath.row, group: group)
            default:
                print("error in didSelectRowAt in HOmeVC")
            }
            
        }else{
            let ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            switch(indexPath.section)
            {
            case 0:
                ChatVC.friend = friendsArray?[indexPath.row]
            case 1:
                ChatVC.group = groupsArr?[indexPath.row]
            default:
                print("error in didSelectRowAt in HOmeVC iPhone")
            }
            
            self.navigationController?.pushViewController(ChatVC, animated: true)
        }
    }

}

extension HomeViewController : HomeViewModelNavigator{
    
    
    
    
    func onAddFriendSelected() {
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            menuDelegate?.AddFriendSelected()
        }else{
            let AddFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
            
            self.navigationController?.pushViewController(AddFriendVC, animated: true)
        }
    }
    
    func onCreateGroupSelected() {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            menuDelegate?.CreateGroupSelected()
        }else{
            let CreateGroupVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as! CreateGroupViewController
            
            self.navigationController?.pushViewController(CreateGroupVC, animated: true)
        }
    }
    
    func onSettingsSelected() {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            menuDelegate?.SettingsSelected()
        }else{
            let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
        
    }
    
    func onLogoutSelected() {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            menuDelegate?.LogoutSelected()
        }else{
            print("logout")
            do
            {
               try Auth.auth().signOut()
//                dismiss(animated: true)
                let signIn = self.storyboard?.instantiateViewController(withIdentifier: "SinginViewController") as! SinginViewController
                
                navigationController?.pushViewController(signIn, animated: true)
                navigationController?.navigationBar.prefersLargeTitles = true
                navigationController?.navigationBar.tintColor = .white
                navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
            }catch let error
            {
                showAlert(title: " Logout", message: "error : \(error.localizedDescription)", onActionClick: nil)
            }
        }
    }
    
    
}
extension HomeViewController : ReloadTableViewDelegate {
//    func getAllGroupChatDelegate() {
//        //create function in viewModel getAll Group chat from DB
//        // binding the GroupChat Array in new section "Groups"then reload Table view
//        homeViewModel?.fetchAllGroupChatFromDB()
//        homeViewModel?.bindingAllGroupChat = {[weak self] groups in
//            self?.groupsArr = groups
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//                self?.view.layoutIfNeeded()
//                self?.view.setNeedsDisplay()
//            }
//        }
//    }
    
    func setFriendRequestsCountDelegate(friendRequestsCount count: Int) {
        friendRequestBtn.setBadge(text: "\(count)" , withOffsetFromTopRight: CGPoint(x: 5, y: -0.7)  )
        if count == 0 {
            friendRequestBtn.removeBadge()
        }
    }
    
    func reloadDataDelegate() {
        homeViewModel?.fetchAllFriendFromDB()
        homeViewModel?.bindingFriends = {[weak self] friends in
            self?.friendsArray = friends
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                
            }
        }
    }
}
//extension HomeViewController : ConversationStatusDelegate {
//    func numberOfUnReadMessagesDelegate(for room: PrivateRoom) {
//        room.isRecieved = true
//        homeViewModel?.fetchAllFriendFromDB()
//        homeViewModel?.bindingFriends = {[weak self] friends in
//            self?.friendsArray = friends
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//
//            }
//        }
//        homeViewModel?.getAllPrivateRoomFromDB()
//        homeViewModel?.bindingAllPrivateRooms = {[weak self] privateRooms in
//            self?.allPrivateRooms = privateRooms
//            for room in self?.allPrivateRooms ?? [] {
//                if (room.senderID == UserProvider.getInstance.getCurrentUser()?.id)
//                    || ( room.recieverID == UserProvider.getInstance.getCurrentUser()?.id)
//                {
//                    self?.roomsArr.append(room)
//                }
//            }
//            DispatchQueue.main.async {
//                self?.tableView.reloadData()
//            }
//        }
//    }
//}
