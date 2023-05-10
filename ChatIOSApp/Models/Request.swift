//
//  Request.swift
//  ChatIOSApp
//
//  Created by Omar on 04/05/2023.
//

import Foundation
enum RequestType :Codable{
    case group
    case friend
}
class Request : Codable{
    var id : String?
    var requestFromName : String?
    var requestFromId : String?
    var requestFromImage : String?
    var requestToName : String?
    var requestToId : String?
    var requestType : RequestType?
    
    init(id: String? = nil, requestFromName: String? = nil, requestFromId: String? = nil
         , requestToName: String? = nil, requestToId: String? = nil , requesrFromImage : String? = nil
         , requestType : RequestType? = nil) {
        self.id = id
        self.requestFromName = requestFromName
        self.requestFromId = requestFromId
        self.requestToName = requestToName
        self.requestToId = requestToId
        self.requestFromImage = requesrFromImage
        self.requestType = requestType
    }
}
