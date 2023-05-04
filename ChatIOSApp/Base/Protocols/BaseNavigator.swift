//
//  Navigator.swift
//  ChatIOSApp
//
//  Created by Omar on 15/04/2023.
//

import UIKit

protocol BaseNavigator {
    func showLoading()
    func showAlert(title : String , message : String ,  onActionClick : (() -> ())? )
    func hideLoading()
    func textFieldStyle(tf:UITextField! , color : UIColor , placeHolder : String)
    
}

