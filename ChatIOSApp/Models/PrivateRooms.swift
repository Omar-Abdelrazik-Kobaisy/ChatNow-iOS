//
//  PrivateRooms.swift
//  ChatIOSApp
//
//  Created by Omar on 28/04/2023.
//

import Foundation
class PrivateRoom : Codable{
    var id : String?
    var senderID : String?
    var senderEmail : String?
    var recieverID : String?
    var recieverEmail : String?
    var isRecieved : Bool?
    var unreadMessages : Int?
    init(id: String? = nil, senderID: String? = nil, senderEmail: String? = nil, recieverID: String? = nil, recieverEmail: String? = nil, isRecieved : Bool? = nil ,unreadMessages : Int? = nil) {
        self.id = id
        self.senderID = senderID
        self.senderEmail = senderEmail
        self.recieverID = recieverID
        self.recieverEmail = recieverEmail
        self.isRecieved = isRecieved
        self.unreadMessages = unreadMessages
    }
}

