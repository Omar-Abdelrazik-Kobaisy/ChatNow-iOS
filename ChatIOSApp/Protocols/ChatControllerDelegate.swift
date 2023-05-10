//
//  ChatControllerDelegate.swift
//  ChatIOSApp
//
//  Created by Omar on 21/04/2023.
//

import Foundation


protocol ChatMenuNavigator {
    func removeFreind()
    func aboutFriend()
    func addPeople()
}
protocol ChatViewModelDelegate {
    func onRemoveFriendSelected()
    func onAboutFriendSelected()
    func onAddPeopleSelected()
}
protocol ChatControllerDelegate {
    func removeFriendSelected()
}
