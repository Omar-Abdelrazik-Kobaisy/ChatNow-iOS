//
//  User.swift
//  ChatIOSApp
//
//  Created by Omar on 17/04/2023.
//

import Foundation
import FirebaseStorage

class User : Codable   {
    var id : String?
    var userName : String?
    var email : String?
    var image : String?
    var about : String?
    //
    var imageRef : String?
    //
    init(id: String? = nil, userName: String? = nil, email: String? = nil, image: String? = nil, about: String? = nil, imageRef : String? = nil) {
        self.id = id
        self.userName = userName
        self.email = email
        self.image = image
        self.about = about
        self.imageRef = imageRef
    }
    
}

