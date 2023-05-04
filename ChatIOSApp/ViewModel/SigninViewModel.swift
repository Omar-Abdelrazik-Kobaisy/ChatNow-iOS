//
//  SigninViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 15/04/2023.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import UIKit


class SigninViewModel : SigninViewDelegate {
    
    
//    var email : String?
//    var password : String?
    var userDataInfo : (email :UITextField , password :UITextField )?
    var navigator : BaseNavigator?
    var signinNavigator : SigninNavigator?
    var isValid = false
    func configureUI(){
        navigator?.textFieldStyle(tf: userDataInfo?.email, color: .systemBlue, placeHolder: "email".localized)
        navigator?.textFieldStyle(tf: userDataInfo?.password, color: .systemBlue, placeHolder: "password".localized)
    }
    func onUserSignin(email: String, password: String) {
        print("email :-> \(userDataInfo?.email.text ?? "")")
        print("password :-> \(userDataInfo?.password.text ?? "")")
        navigator?.showLoading()
        Auth.auth().signIn(withEmail: email, password: password)  {[self] authResult, error in
        navigator?.hideLoading()
        if let e = error {
            // fail
            navigator?.showAlert( title: "LogIn Status", message: "error\(e.localizedDescription)", onActionClick: nil)
        }else{
            //success
            guard let result = authResult else{return}
            
            FireStoreUtils.sharedInstance.getUser(uid: result.user.uid) { [self] user, error in
                if let e = error {
                    //fail
                    navigator?.showAlert( title: "LogIn_Status".localized, message: "error".localized+" :\(e.localizedDescription)", onActionClick: nil)
                }else{
                    //success
                    UserDefaults.standard.set(ModelController().convert(from: user).toData, forKey: "user")

                    UserProvider.getInstance.user = user
                    signinNavigator?.goToHome()
                }
            }
            
        }
    }
    }
        func Validate() -> Bool{
            isValid = true
            if let email = userDataInfo?.email , let password = userDataInfo?.password{
                if(email.text!.isEmptyOrBlanck() ){
                    email.text?.removeAll()
                    isValid = false
                    navigator?.textFieldStyle(tf: email, color: .red, placeHolder: "please_enter_your_email".localized) 
                    navigator?.textFieldStyle(tf: password, color: .systemBlue, placeHolder: "password".localized)
                }else if(password.text!.isEmptyOrBlanck() ){
                    password.text?.removeAll()
                    isValid = false
                    navigator?.textFieldStyle(tf: password, color: .red, placeHolder: "please_enter_your_password".localized)
                    navigator?.textFieldStyle(tf: email, color: .systemBlue, placeHolder: "email".localized)
                }
                else{
                    isValid = true
                    navigator?.textFieldStyle(tf: email, color: .systemBlue, placeHolder: "email".localized)
                    
                    navigator?.textFieldStyle(tf: password, color: .systemBlue, placeHolder: "password".localized)
                }
                
            }
            return isValid
        }
}
