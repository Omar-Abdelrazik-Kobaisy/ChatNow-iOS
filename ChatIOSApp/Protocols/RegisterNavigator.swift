//
//  RegisterNavigator.swift
//  ChatIOSApp
//
//  Created by Omar on 17/04/2023.
//
import Firebase
import FirebaseAuth
protocol RegisterNavigator {
    func goToUserDetails(result: AuthDataResult)
}
