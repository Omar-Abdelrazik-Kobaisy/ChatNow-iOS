//
//  RegisterViewDelegate.swift
//  ChatIOSApp
//
//  Created by Omar on 15/04/2023.
//

protocol RegisterViewDelegate {
    func configureUI()
    func onUserRegister( userEmail : String ,
                        userPassword : String )
    func Validate() -> Bool
}
