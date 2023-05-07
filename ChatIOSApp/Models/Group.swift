//
//  Group.swift
//  ChatIOSApp
//
//  Created by Omar on 07/05/2023.
//

import Foundation
class Group : Codable {
    var id : String?
    var name : String?
    var imageREF : String?
    var description : String?
    var users : [User]?
    
    init(id : String? = nil , name : String? = nil ,imageREF : String? = nil , description : String? = nil , users : [User]? = nil){
        self.id = id
        self.name = name
        self.imageREF = imageREF
        self.description = description
        self.users = users
    }
}
