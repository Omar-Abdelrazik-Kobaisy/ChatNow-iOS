//
//  SigninViewDelegate.swift
//  ChatIOSApp
//
//  Created by Omar on 15/04/2023.
//

protocol SigninViewDelegate {
    func configureUI()
    func onUserSignin(email : String
                      , password : String)
    func Validate() -> Bool
}
