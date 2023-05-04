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
}

protocol ReloadTableView {
    func reloadData()
}
