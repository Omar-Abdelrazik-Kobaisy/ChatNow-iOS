//
//  HomeControllerDelegate.swift
//  ChatIOSApp
//
//  Created by Omar on 20/04/2023.
//

import Foundation


protocol MenuNavigator{
    func AddFriend()
    func CreateGroup()
    func Settings()
    func Logout() 
}
protocol HomeViewModelNavigator {
    func onAddFriendSelected()
    func onCreateGroupSelected()
    func onSettingsSelected()
    func onLogoutSelected()
}
protocol HomeControllerDelegate : AnyObject {
    func didTapItem(index : Int , friend : User)
    func didTapItem(index : Int , group : Group)
    func AddFriendSelected()
    func CreateGroupSelected()
    func SettingsSelected()
    func LogoutSelected()
    func FriendRequestSelected()
}
