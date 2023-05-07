//
//  CreateGroupViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 07/05/2023.
//

import Foundation
import UIKit
class CreateGroupViewModel {
    
    var navigator : BaseNavigator?
    var createGroupInfo : (groupName :UITextField ,groupDescription :UITextField , groupImage :UIImageView)?
    
    func configureUI(){
        navigator?.textFieldStyle(tf: createGroupInfo?.groupName, color: .systemBlue, placeHolder: "GroupName")
        navigator?.textFieldStyle(tf: createGroupInfo?.groupDescription, color: .systemBlue, placeHolder: "GroupDescription")
    }
    
    func onAddGroup(){
        // obj of type Group
        // add this obj to DB
//        guard let currentUser = UserProvider.getInstance.getCurrentUser() else { return }
//        let group = Group(name: createGroupInfo?.groupName , imageREF: <#T##String?#> , description: createGroupInfo?.groupDescription ,users: <#T##[User]?#>)
//        FireStoreUtils.sharedInstance.addGroup(<#T##group: Group##Group#>, to: currentUser, onCompleteDelegate: <#T##(Error?) -> (Void)#>)
    }
}
