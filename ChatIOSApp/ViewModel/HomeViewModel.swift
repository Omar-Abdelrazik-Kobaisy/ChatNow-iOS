//
//  HomeViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 19/04/2023.
//
import Foundation
import UIKit


class HomeViewModel: MenuNavigator{
    func AddFriend() {
        viewModelNavigator?.onAddFriendSelected()
    }
     
    func CreateGroup() {
        viewModelNavigator?.onCreateGroupSelected()
    }
    
    func Settings() {
        viewModelNavigator?.onSettingsSelected()
    }
    
    func Logout() {
        viewModelNavigator?.onLogoutSelected()
    }
    
    var bindingFriends : ([User])->(Void) = {_ in}
    var bindingImageData : ((Data?)->(Void)) = {_ in}
    var friends : [User] = []{
        didSet{
            //binding
            bindingFriends(friends)
        }
    }
    
    var imageData : Data = Data(){
        didSet{
            bindingImageData(imageData)
        }
    }
    var navigator : BaseNavigator?
    var menuItems :[MenuItem] = []
    var viewModelNavigator : HomeViewModelNavigator?
    init(viewModelNavigator : HomeViewModelNavigator){ 
        self.viewModelNavigator = viewModelNavigator
        let addFriend = AddFriendMenuItem(title: "add_friend".localized , image: UIImage(systemName: Constant.ADD_FRIEND_IMAGE), navigator: self)
        let createGroup = CreateGroupMenuItem(title: "create_group".localized , image: UIImage(systemName: Constant.CREATE_GROUP_IMAGE ), navigator: self)
        let settings = SettingMenuItem(title: "settings".localized , image: UIImage(systemName: Constant.SETTINGS_IMAGE), navigator: self)
        let logout = LogoutMenuItem(title: "log_out".localized , image: UIImage(systemName: Constant.LOGOUT_IMAGE), navigator: self)
        
        menuItems.append(contentsOf: [addFriend , createGroup , settings , logout])
        
    }
    
    func fetchAllFriendFromDB(){
        print("\(UserProvider.getInstance.getCurrentUser()?.id ?? "")")
        FireStoreUtils.sharedInstance.getAllFriends(uid: UserProvider.getInstance.getCurrentUser()?.id ?? "") { [weak self] users, error in
            if let e = error {
                self?.navigator?.showAlert(title: "error".localized, message: "\(e.localizedDescription)", onActionClick: nil)
            }
            else{
                self?.friends = users
            }
        }
    }
    
    func downloadImageFromDB(imageURL : String){
        StorageUtils.sharedInstance.downloadImage(ImageURL: imageURL) {[weak self] data in
            self?.imageData = data
        }
    }
    
}
