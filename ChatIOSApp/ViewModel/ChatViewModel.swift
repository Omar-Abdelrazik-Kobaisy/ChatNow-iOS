//
//  ChatViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 21/04/2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseStorageUI
class ChatViewModel {
    var chatUI : (message : UITextField , tableV : UITableView)?
    var menuItems : [MenuItem] = []
    var viewModelDelegate : ChatViewModelDelegate?
    var navigator : BaseNavigator?
    
    var bindingRooms : (([PrivateRoom])->(Void)) = {_ in}
    var bindingMessages : (([Message])->(Void)) = {_ in}
    
    var rooms : [PrivateRoom] = []{
        didSet{
            //binding
            bindingRooms(rooms)
        }
    }
    
    var messages : [Message] = [] {
        didSet{
            //binding
            bindingMessages(messages)
        }
    }
    
    
    init(viewModelDelegate : ChatViewModelDelegate , navigator : BaseNavigator){
        self.viewModelDelegate = viewModelDelegate
        self.navigator = navigator
        let removeFriend = RemoveFriendItem(title:"Remove",image: UIImage(systemName: Constant.REMOVE_IMAGE),chatNavigator: self)
        let aboutFriend = AboutFriendItem(title : "About", image : UIImage(systemName: Constant.FRIEND_DETAILS) , chatNavigator: self)
        
        
        menuItems.append(contentsOf: [removeFriend , aboutFriend])
    }
    
    func configureUI(){
        navigator?.textFieldStyle(tf: chatUI?.message, color: .systemBlue, placeHolder: "enter your message")
        
        if UserDefaults.standard.bool(forKey: "Theme")
        {
            chatUI?.tableV.backgroundView = UIImageView(image: UIImage(named: "chat_imge_bg"))
        }else{
            chatUI?.tableV.backgroundView = UIImageView(image: UIImage(named: "dark-bg"))
        }
//            chatUI?.tableV.backgroundView = UIImageView(image: UIImage(named: "chat_imge_bg"))
            
        
        
    }
    
    func addMessageToDB(from user : User ,to friend : User , rooms : [PrivateRoom]?){
        let message =
        Message(content: chatUI?.message.text
            ,senderId: user.id
            ,senderName: user.userName
                ,recieverId: friend.id , recieverName: friend.userName
                ,dateTime: getCurrentDate())
              
        FireStoreUtils.sharedInstance.sendMessage(message, from: user , to: friend , rooms: rooms ) { [weak self] error in
            if let e = error{
                //fail
                self?.navigator?.showAlert(title: "Send Message", message: "error : \(e.localizedDescription)", onActionClick: nil)
            }else{
                //success
                self?.chatUI?.message.text = ""
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
    func getAllMessagesFromDB(roomID : String){
        FireStoreUtils.sharedInstance.getAllMessages(roomID: roomID) {[weak self] messages in
            self?.messages = messages
        }
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    
    func navTitleWithImageAndText(titleText: String, imageName: String) -> UIView {

        // Creates a new UIView
        let titleView = UIView()

        
        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center

        // Creates the image view
        let image = UIImageView()
        if let imageREF = StorageUtils.sharedInstance.storageReference?.child(imageName) {
            image.sd_setImage(with: imageREF, placeholderImage: UIImage(named: "1"))
        } else{
            print(" error in loading image in cell ")
        }
//        image.image = UIImage(named: imageName)

        // Maintains the image's aspect ratio:
//        let imageAspect = image.image!.size.width / image.image!.size.height

        // Sets the image frame so that it's immediately before the text:
        let imageX = label.frame.origin.x - 60
        let imageY = label.frame.origin.y - 12

//        let imageWidth = label.frame.size.width
//        let imageHeight = label.frame.size.height
        image.frame = CGRect(x: imageX, y: imageY, width: 45, height: 43)
        image.layer.borderWidth = 1
            image.layer.masksToBounds = false
            image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.size.height/5
            image.clipsToBounds = true
        

        image.contentMode = UIView.ContentMode.scaleToFill

        // Adds both the label and image view to the titleView
        titleView.addSubview(label)
        titleView.addSubview(image)

        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()

        return titleView

    }
}

extension ChatViewModel : ChatMenuNavigator {
    func removeFreind() {
        viewModelDelegate?.onRemoveFriendSelected()
    }
    
    func aboutFriend() {
        viewModelDelegate?.onAboutFriendSelected()
    }
    
    
}
