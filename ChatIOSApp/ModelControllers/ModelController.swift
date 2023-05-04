//
//  ModelController.swift
//  ChatIOSApp
//
//  Created by Omar on 28/04/2023.
//

import Foundation

class ModelController {
    func convert<T : Codable>(from obj : T) -> (toDictionary : [String:Any] , toData : Data?){
        var dictionary : [String:Any] = [:]
        var data : Data?
        do {
            data = try JSONEncoder().encode(obj)
            if let myData = data {
                dictionary = try JSONSerialization.jsonObject(with: myData) as! [String : Any]
            }
        }catch let error {
            print(error.localizedDescription)
        }
        
        return (dictionary , data)
    }
    func convert<T : Codable>(dictionary : [String : Any] , ToObj obj : T) -> T? {
        var obj : T?
        do
        {
            let data = try JSONSerialization.data(withJSONObject: dictionary)
            obj = try JSONDecoder().decode(T.self, from: data)
        }catch let error {
            print(error.localizedDescription)
        }
        return obj
    }
}
