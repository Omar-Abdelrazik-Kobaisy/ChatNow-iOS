//
//  GroupMessage.swift
//  ChatIOSApp
//
//  Created by Omar on 09/05/2023.
//

import Foundation
class GroupMessage : Codable {
    var id : String?
    var groupName : String?
    var groupID : String?
    var content : String?
    var dateTime : String?
    var senderName : String?
    var senderID : String?
    
    init(id : String? = nil , groupName : String? = nil , groupID : String? = nil , content : String? = nil,
         dateTime : String? = nil , senderName : String? = nil , senderID : String? = nil)
    {
        self.id = id
        self.groupName = groupName
        self.groupID = groupID
        self.content = content
        self.dateTime = dateTime
        self.senderName = senderName
        self.senderID = senderID
    }
}
