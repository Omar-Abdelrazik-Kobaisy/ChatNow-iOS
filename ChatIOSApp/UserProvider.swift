//
//  UserProvider.swift
//  ChatIOSApp
//
//  Created by Omar on 23/04/2023.
//

import Foundation
class UserProvider {
    static let getInstance = UserProvider()
    var user : User? = nil
    private init(){
        
    }
    func getCurrentUser() -> User? {
        var user : User?
        if let data = UserDefaults.standard.data(forKey: "user") {
            do
            {
                user = try JSONDecoder().decode(User.self, from: data)
            }catch let error {
                print(error.localizedDescription)
            }
        }
        return user
    }
}
