//
//  FriendRequestTableViewDelegate.swift
//  ChatIOSApp
//
//  Created by Omar on 05/05/2023.
//

import Foundation
protocol OnClickTableViewDelegate{
    func onConfirm(friend : FriendRequestTableViewCell)
    func onReject(friend : FriendRequestTableViewCell)
}
