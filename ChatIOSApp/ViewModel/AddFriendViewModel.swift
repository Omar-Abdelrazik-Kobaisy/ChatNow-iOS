//
//  AddFriendViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 24/04/2023.
//

import Foundation
import UIKit
class AddFriendViewMidel {
    
    
    var bidingUsers :(([User])->(Void)) = {_ in }
    var bindindRooms : (([PrivateRoom])->(Void)) = {_ in}
    var navigator : BaseNavigator?
    var users : [User] = [] {
        didSet{
            //binding
            bidingUsers(users)
        }
    }
    
    var rooms : [PrivateRoom] = []{
        didSet{
            //binding
            bindindRooms(rooms)
        }
    }
    
    func getUsersFromDB(){
        FireStoreUtils.sharedInstance.getAllUsers { [weak self] users, e in
            if let e = e {
                //fail
                self?.navigator?.showAlert(title: "ADD Friend", message: "error \(e.localizedDescription)", onActionClick: nil)
            }else{
                //success
                self?.users = users
            }
        }
    }
    
    func addFriendToDB(user : User , firend : User , reloadTV : ReloadTableView?){
        FireStoreUtils.sharedInstance.addFriend(user: user, friend: firend) { [weak self]error in
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
    func createRoom(rooms : [PrivateRoom]? , room : PrivateRoom , user : User , friend : User){
        FireStoreUtils.sharedInstance.createPrivateRoom(rooms : rooms ,room: room ) {[weak self] error in
            if let e = error {
                //fail
                self?.navigator?.showAlert(title: "ADD Friend", message: "error : \(e.localizedDescription)", onActionClick: nil)
            }else{
                //success
                print("room created successfully")
            }
        }
    }
    func getAllPrivateRoomFromDB(){
        FireStoreUtils.sharedInstance.getAllPrivateRoom {[weak self] privateRooms, error in
            if let e = error {
             //fail
                self?.navigator?.showAlert(title: "error", message: "\(e.localizedDescription)", onActionClick: nil)
            }else{
                //success
                self?.rooms = privateRooms
            }
        }
    }
    
    func sendRequest(request req :Request , to friend : User){
        FireStoreUtils.sharedInstance.makeRequest(request: req, to: friend) { [weak self] error in
            if let e = error {
                //fail
                self?.navigator?.showAlert(title: "Request_Status", message: "error : \(e.localizedDescription)", onActionClick: nil)
            }else{
                //success
                print("Request send to \(friend.userName ?? "")")
            }
        }
    }
}
