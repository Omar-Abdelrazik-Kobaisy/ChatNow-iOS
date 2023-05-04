//
//  UserDetailsViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 17/04/2023.
//

import Foundation
import UIKit

class UserDetailsViewModel : UserDetailsViewDelegate {
    
    
    
    var bindingImageURL : ((String?) ->Void) = {_ in }
    var bindingImageRef : ((String?) ->Void) = {_ in }
    var userDetailsNavigator : UserDetailsNavigator?
    
    var imageURL : String? {
        //binding
        didSet{ 
            bindingImageURL(imageURL)
        }
    }
    var imageRef : String? {
        didSet{
            //binding
            bindingImageRef(imageRef)
        }
    }
    
    func insertImageToDataBase(imageData: Data, userEmail: String) {
        StorageUtils.sharedInstance.uploadImage(imageData: imageData, userEmail: userEmail)
        {[weak self] imgURL,imgREF  in
            self?.imageURL = imgURL
            self?.imageRef = imgREF
        }
    }
    func inserUserToDataBase(user: User) {
        FireStoreUtils.sharedInstance.addUser(user: user) { [weak self] error in
            if let e = error {
                //fail
                print(e.localizedDescription)
            }else{
                //success 
                print("Go to Home")
//                UserProvider.getInstance.user = user
                UserDefaults.standard.set(ModelController().convert(from: user).toData, forKey: "user")
                self?.userDetailsNavigator?.navigateToHomeVC()
//                if UIDevice.current.userInterfaceIdiom == .pad{
//                    self?.userDetailsNavigator?.navigateToSplit()
//                }else {
//                    self?.userDetailsNavigator?.navigateToHomeVC()
//                }
            }
        }
    }
}
