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

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var HomeMenuOptions: UIBarButtonItem!
    var homeViewModel : HomeViewModel?
    var delegate : HomeControllerDelegate?
    var menuDelegate : HomeControllerDelegate?
    var friendRequestDelegate : HomeControllerDelegate?
    var friendsArray : [User]?
//    var requestsArr : [Request]?
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
//        let friendRequestVM = FriendRequestViewModel()
//        friendRequestVM.fetchAllRequestFromDB()
//        friendRequestVM.bindingAllRequest = {[weak self] requests in
//            self?.requestsArr = requests
//        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let rightBarButton = self.navigationItem.rightBarButtonItem

        rightBarButton?.addBadge(text: "3" , withOffset: CGPoint(x: -50, y: 0))
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friendsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! HomeTableViewCell
        
        cell.userName.text = friendsArray?[indexPath.row].userName
        cell.userAbout.text = friendsArray?[indexPath.row].about
        if let imageREF = StorageUtils.sharedInstance.storageReference?.child(friendsArray?[indexPath.row].imageRef ?? "")  {
            cell.userImage.sd_setImage(with: imageREF, placeholderImage: UIImage(named: "1"))
        }else{
            print(" error in loading image in cell ")
        }
        
        cell.messageCount.text = "999"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}
extension HomeViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath(row: indexPath.row, section: 0), animated: true)
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            guard let friend = friendsArray?[indexPath.row] else {
                return
            }
            delegate?.didTapItem(index: indexPath.row , friend: friend)
        }else{
            let ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            ChatVC.friend = friendsArray?[indexPath.row]
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
