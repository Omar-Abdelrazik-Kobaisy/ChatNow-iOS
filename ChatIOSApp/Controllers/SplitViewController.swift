//
//  SplitViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 19/04/2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth

class SplitViewController: UISplitViewController{

    var primaryVC : HomeViewController!
    var secondaryVC : SecondaryViewController!
    
    var reloadDelegate : ReloadTableViewDelegate?
//    var deleteDelegate : DeleteFromTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        primaryVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        primaryVC.delegate = self
        primaryVC.menuDelegate = self
        primaryVC.friendRequestDelegate = self
        secondaryVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondaryViewController") as? SecondaryViewController
        
        self.viewControllers = [primaryVC , UINavigationController(rootViewController: secondaryVC)]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SplitViewController : HomeControllerDelegate {
    func FriendRequestSelected() {
        let friendRequestVC = self.storyboard?.instantiateViewController(withIdentifier: "FriendRequestViewController") as! FriendRequestViewController
        
        (self.viewControllers.last as? UINavigationController)?.pushViewController(friendRequestVC, animated: true)
        friendRequestVC.reloadTV = self
    }
     
    func AddFriendSelected() {
        let addFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
        
        (self.viewControllers.last as? UINavigationController)?.pushViewController(addFriendVC, animated: true)
        addFriendVC.reload = self
    }
     
    func CreateGroupSelected() {
        let createGroupVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as! CreateGroupViewController
        
        (self.viewControllers.last as? UINavigationController)?.pushViewController(createGroupVC, animated: true)
    }
    
    func SettingsSelected() {
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        (self.viewControllers.last as? UINavigationController)?.pushViewController(settingsVC, animated: true)
    }
    
    func LogoutSelected() {
        print("logout") 
        do
        {
           try Auth.auth().signOut()
            let signIn = self.storyboard?.instantiateViewController(withIdentifier: "SinginViewController") as! SinginViewController
            print("\(String(describing: self.navigationController?.viewControllers.count) )")
            print("\(String(describing: self.navigationController?.viewControllers.first?.description))")

            self.dismiss(animated: true)
            
                self.navigationController?.pushViewController(signIn, animated: true)
                self.navigationController?.navigationBar.prefersLargeTitles = true
                self.navigationController?.navigationBar.tintColor = .white
                self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
        }catch let error
        {
            print(error.localizedDescription)
        }
    }
    
    
    func didTapItem(index: Int, friend: User) {
        (self.viewControllers.last as? UINavigationController)?.popToRootViewController(animated: true)
        let ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        ChatVC.friend = friend
        (self.viewControllers.last as? UINavigationController)?.pushViewController(ChatVC, animated: true)
    }
    
    
}
extension SplitViewController : ReloadTableView {
    func setFriendRequestsCount(friendRequestsCount count: Int) {
        reloadDelegate = primaryVC
        reloadDelegate?.setFriendRequestsCountDelegate(friendRequestsCount: count)
    }
    
    func reloadData() {
        reloadDelegate = primaryVC
        reloadDelegate?.reloadDataDelegate()
    }
}

//extension SplitViewController : DeleteFromTableView{
//    func deleteData() {
//        deleteDelegate = secondaryVC
//        deleteDelegate?.deleteDataDelegate()
//    }
//}
