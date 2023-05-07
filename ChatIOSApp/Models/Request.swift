//
//  Request.swift
//  ChatIOSApp
//
//  Created by Omar on 04/05/2023.
//

import Foundation
class Request : Codable{
    var id : String?
    var requestFromName : String?
    var requestFromId : String?
    var requestFromImage : String?
    var requestToName : String?
    var requestToId : String?
    
    init(id: String? = nil, requestFromName: String? = nil, requestFromId: String? = nil, requestToName: String? = nil, requestToId: String? = nil , requesrFromImage : String? = nil) {
        self.id = id
        self.requestFromName = requestFromName
        self.requestFromId = requestFromId
        self.requestToName = requestToName
        self.requestToId = requestToId
        self.requestFromImage = requesrFromImage
    }
}
