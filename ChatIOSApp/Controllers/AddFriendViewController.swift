//
//  AddFriendViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 20/04/2023.
//

import UIKit

class AddFriendViewController: BaseViewController {

    @IBOutlet weak var enterFriendIDTF: UITextField!
    
    @IBOutlet weak var simpleLable: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    var viewModel : AddFriendViewMidel?
    var arr : [User]?
    var group : Group?
    var privateRoomsArr : [PrivateRoom]?
    var reload : ReloadTableView?
//    var reloadGroup : ReloadGroups?
    override func viewDidLoad() {
        super.viewDidLoad() 

        textFieldStyle(tf: enterFriendIDTF, color: .systemBlue, placeHolder: "enter_your_friend_id".localized)
        
        viewModel = AddFriendViewMidel()
        viewModel?.navigator = self
        viewModel?.getUsersFromDB()
        viewModel?.getAllPrivateRoomFromDB()
        viewModel?.bidingUsers = {[weak self]users in
            self?.arr = users
        }
        viewModel?.bindindRooms = {[weak self]rooms in
            self?.privateRoomsArr = rooms
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        simpleLable.text = "enter_your_friend_id".localized
        addBtn.titleLabel?.text = "add".localized
    }
    

    @IBAction func onAddFriend(_ sender: UIButton) {
            print("clicked")
            guard let currentUser = UserProvider.getInstance.getCurrentUser() else {return}
            print(currentUser.email ?? "")
            for user in arr ?? [] {
                //                print("\(String(describing: user.userName))")
                print("\(String(describing: user.id)) --> \(enterFriendIDTF.text ?? "")")
                if user.id == enterFriendIDTF.text ?? "" {
                    // add friend to fireStore
                    print("\(String(describing: user.userName))")
                    if let group = group{
                        // add this user to group
//                                                                  , reloadTV: reloadGroup
                        viewModel?.add(friend: user, toGroup: group )
//                        let request = Request(requestFromName: group.name , requestFromId: group.id , requestToName: user.userName , requestToId: user.id , requesrFromImage: group.imageREF , requestType: .group)
//                        viewModel?.sendRequest(request: request, to: user)
                    }else{
                        viewModel?.addFriendToDB(user: currentUser , firend: user , reloadTV : reload)
                        
                        let room = PrivateRoom(senderID: currentUser.id , senderEmail: currentUser.email
                                               , recieverID: user.id , recieverEmail: user.email)
                        viewModel?.createRoom(rooms : privateRoomsArr, room: room, user: currentUser, friend: user)
                        let request = Request(requestFromName: currentUser.userName , requestFromId: currentUser.id , requestToName: user.userName , requestToId: user.id , requesrFromImage: currentUser.imageRef , requestType: .friend)
                        viewModel?.sendRequest(request: request, to: user)
                    }
                }
            }
            
        //add people to selected group
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

    
    

