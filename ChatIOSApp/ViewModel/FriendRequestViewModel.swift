//
//  FriendRequestViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 05/05/2023.
//

import Foundation
import UIKit
class FriendRequestViewModel {
    var navigator : BaseNavigator?
    var bindingAllRequest : (([Request])->(Void)) = {_ in}
    
    var allRequest : [Request] = [] {
        didSet{
            //binding
            bindingAllRequest(allRequest)
        }
    }
    
    
    func fetchAllRequestFromDB(){
        guard let user = UserProvider.getInstance.getCurrentUser() else { return }
        FireStoreUtils.sharedInstance.getAllRequest(user: user) { [weak self] requests in
            self?.allRequest = requests
        }
    }
    
    func addFriendToDB(friendID : String , reloadTV : ReloadTableView?){
        FireStoreUtils.sharedInstance.getUser(uid: friendID) { [weak self]user, error in
            if let e = error {
                //fail
                self?.navigator?.showAlert(title: "error", message: "\(e.localizedDescription)", onActionClick: nil)
            }else{
                //success
                guard let currentUser = UserProvider.getInstance.getCurrentUser() else { return }
                FireStoreUtils.sharedInstance.addFriend(user: currentUser , friend: user) { error in
                    if let e = error {
                        //fail
                        self?.navigator?.showAlert(title: "ADD Friend", message: "\(e.localizedDescription)", onActionClick: nil)
                    }else{
                        // success
                        self?.navigator?.showAlert(title: "ADD Friend", message: "Successfully Added", onActionClick: {
                            if UIDevice.current.userInterfaceIdiom == .pad
                            {
                                reloadTV?.reloadData()
                            }else{
                                // back to home View Controller
                            }
                        })
                    }
                }
            }
        }
    }
    func deleteFromDB(reqId : String , onCompleteDelegate : @escaping (Error?)->(Void) ){
        guard let currentUser = UserProvider.getInstance.getCurrentUser() else { return }
        FireStoreUtils.sharedInstance.deleteRequest(user: currentUser, requestId: reqId) { error in
            onCompleteDelegate(error)
        }
    }
}
