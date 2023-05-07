//
//  ReloadTableView.swift
//  ChatIOSApp
//
//  Created by Omar on 01/05/2023.
//

import Foundation
import UIKit

protocol ReloadTableViewDelegate{
    func reloadDataDelegate()
    func setFriendRequestsCountDelegate(friendRequestsCount count:Int)
}

protocol ReloadTableView {
    func reloadData()
    func setFriendRequestsCount(friendRequestsCount count:Int)
    func reloadFriends()
}

protocol DeleteFromTableViewDelegate{
    func deleteDataDelegate()
}

protocol DeleteFromTableView{
    func deleteData()
}
