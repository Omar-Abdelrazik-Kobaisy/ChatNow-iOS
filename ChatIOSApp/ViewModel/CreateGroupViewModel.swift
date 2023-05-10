//
//  CreateGroupViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 07/05/2023.
//

import Foundation
import UIKit
class CreateGroupViewModel {
    
    var bindingImageURL : ((String?) ->Void) = {_ in }
    var bindingImageRef : ((String?) ->Void) = {_ in }
    var navigator : BaseNavigator?
    var createGroupInfo : (groupName :UITextField ,groupDescription :UITextField ,
                           groupImage :UIImageView , groupImgREF :String?)?
    
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
    
    func configureUI(){
        navigator?.textFieldStyle(tf: createGroupInfo?.groupName, color: .systemBlue, placeHolder: "GroupName")
        navigator?.textFieldStyle(tf: createGroupInfo?.groupDescription, color: .systemBlue, placeHolder: "GroupDescription")
    }
    
    func onAddGroup(_ group : Group ){
        // obj of type Group
        // add this obj to DB
        FireStoreUtils.sharedInstance.createGroupChat(group) {[weak self] error in
            if let e = error {
                //fail
                self?.navigator?.showAlert(title: "ADD Group", message: "error : \(e.localizedDescription)", onActionClick: nil)
            }else{
                //success
                self?.navigator?.showAlert(title: "ADD Group", message: "Group Created Successfully", onActionClick: nil)
            }
        }
    }
    
    func insertImageToDB(imgData : Data){
        guard let currentUser = UserProvider.getInstance.getCurrentUser() else { return }
        let uniqueID = String((currentUser.id ?? "0123456789").shuffled())+"\(Double.random(in: 1...10))"
        print(uniqueID)
        StorageUtils.sharedInstance.uploadImage(imageData: imgData, userEmail: uniqueID) {[weak self] imgURL, imgREF in
            self?.imageURL = imgURL
            self?.imageRef = imgREF
        }
    }
}
