//
//  Menu.swift
//  ChatIOSApp
//
//  Created by Omar on 21/04/2023.
//

import Foundation
import UIKit
import MOLH

class MenuItem{
    var title: String?
    var image : UIImage?
    var navigator : MenuNavigator?
    var chatNavigator : ChatMenuNavigator?
    var settingsNavigator : SettingsMenuNavigator?
    init(title: String? = nil, image: UIImage? = nil, navigator : MenuNavigator? = nil , chatNavigator : ChatMenuNavigator? = nil , settingsNavigator : SettingsMenuNavigator? = nil) {
        self.title = title
        self.image = image
        self.navigator = navigator
        self.chatNavigator = chatNavigator
        self.settingsNavigator = settingsNavigator
    }
    func MenuItemAction(){
        
    }
}
class AddFriendMenuItem : MenuItem{
    override func MenuItemAction() {
        navigator?.AddFriend()
    }
}
class CreateGroupMenuItem : MenuItem{
    override func MenuItemAction() {
        navigator?.CreateGroup()
    }
}
class SettingMenuItem : MenuItem{
    override func MenuItemAction() {
        navigator?.Settings()
    }
}
class LogoutMenuItem : MenuItem{
    override func MenuItemAction() {
        navigator?.Logout()
    }
}
class RemoveFriendItem : MenuItem {
    override func MenuItemAction() {
        chatNavigator?.removeFreind()
    }
}
class AboutFriendItem : MenuItem {
    override func MenuItemAction() {
        chatNavigator?.aboutFriend()
    }
}

class AddPeople: MenuItem{
    override func MenuItemAction() {
        chatNavigator?.addPeople()
    }
}

class ArabicItem : MenuItem {
    override func MenuItemAction() {
       
        settingsNavigator?.ArabicItemSelected()
    }
}
class EnglishItem : MenuItem {
    override func MenuItemAction() {

        settingsNavigator?.EnglishItemSelected()
        
    }
}
