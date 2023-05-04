//
//  Message.swift
//  ChatIOSApp
//
//  Created by Omar on 27/04/2023.
//

import Foundation
import Firebase
import FirebaseCore
class Message :  Codable {
    var id : String?
    var content : String?
    var senderId : String?
    var senderName : String?
    var recieverId : String?
    var recieverName : String?
    var dateTime : String?
    var isRecieved : Bool?
    var roomID : String?
    
    init(id: String? = nil, content: String? = nil, senderId: String? = nil, senderName: String? = nil, recieverId: String? = nil, recieverName: String? = nil, dateTime: String? = nil, isRecieved: Bool? = nil , roomID : String? = nil) {
        self.id = id
        self.content = content
        self.senderId = senderId
        self.senderName = senderName
        self.recieverId = recieverId
        self.recieverName = recieverName
        self.dateTime = dateTime
        self.isRecieved = isRecieved
        self.roomID = roomID
    }
}

