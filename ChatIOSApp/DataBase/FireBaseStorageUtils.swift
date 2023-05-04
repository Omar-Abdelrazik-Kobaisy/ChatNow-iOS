//
//  FireBaseStorageUtils.swift
//  ChatIOSApp
//
//  Created by Omar on 17/04/2023.
//

import Foundation
import FirebaseStorage

class StorageUtils {
    
    static let sharedInstance = StorageUtils()
    let storageReference : StorageReference?
    var navigator : BaseNavigator?
    private init(){
        storageReference = Storage.storage().reference()
    }
    func uploadImage(imageData: Data , userEmail : String , completion : @escaping (String,String) ->(Void)){
        navigator?.showLoading()
        let src = "iosUserImages/\(userEmail).png"
        let imageReference = storageReference?.child(src)
        
        imageReference?.putData(imageData,metadata: nil) { [self] metadata, error in
            navigator?.hideLoading()
            if let e = error {
                
                navigator?.showAlert(title: "error while upload image", message: "\(e.localizedDescription)", onActionClick: nil)
            }else{
                imageReference?.downloadURL { url, error in
                    if let e = error  {
                        print(e.localizedDescription)
                        return
                    }
                    guard let url = url else {
                        print("error in download URL")
                        return
                    }
                    completion(url.absoluteString,src)
                    print("Download URL :-> \(url.absoluteString)")
                }
            }
        }
    }
    
    func downloadImage(ImageURL : String , complition : @escaping (Data)->(Void) ){
        navigator?.showLoading()
        guard let req = URL(string: ImageURL) else { return }
        URLSession.shared.dataTask(with: req) { [weak self] data, _, error in
            self?.navigator?.hideLoading()
            if let e = error {
                //fail
                self?.navigator?.showAlert(title: "error", message: "\(e.localizedDescription)", onActionClick: nil)
            }else{
                //success
                guard let data = data else{ return }
                complition(data)
            }
        }.resume()
    }
}
