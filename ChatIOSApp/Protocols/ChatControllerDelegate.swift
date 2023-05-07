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
}
protocol ChatViewModelDelegate {
    func onRemoveFriendSelected()
    func onAboutFriendSelected()
}
protocol ChatControllerDelegate {
    func removeFriendSelected()
}
