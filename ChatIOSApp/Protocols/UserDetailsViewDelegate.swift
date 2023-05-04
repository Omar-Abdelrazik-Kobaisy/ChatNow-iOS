//
//  UserDetailsViewDelegate.swift
//  ChatIOSApp
//
//  Created by Omar on 17/04/2023.
//

import Foundation

protocol UserDetailsViewDelegate {
    func insertImageToDataBase(imageData: Data, userEmail: String)
    func inserUserToDataBase(user : User)
}
