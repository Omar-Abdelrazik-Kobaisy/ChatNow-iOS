//
//  RegisterViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 15/04/2023.
//

import Firebase
import FirebaseAuth

class RegisterViewModel  : RegisterViewDelegate{

//    var userName : String? 
//    var userEmail : String?
//    var userPassword : String?
//    var userConfirmPassword : String?
    var isValid = false
    var userDataInfo : (name :UITextField , email :UITextField ,
                        password :UITextField , confirmPassword :UITextField )?
    var navigator : BaseNavigator?
    var registerNavigator : RegisterNavigator?
    

    func configureUI() {
        navigator?.textFieldStyle(tf: userDataInfo?.email , color: .systemBlue , placeHolder: "email".localized)
        navigator?.textFieldStyle(tf: userDataInfo?.password, color: .systemBlue , placeHolder: "password".localized)
        navigator?.textFieldStyle(tf: userDataInfo?.name , color: .systemBlue , placeHolder: "user_name".localized)
        navigator?.textFieldStyle(tf: userDataInfo?.confirmPassword,color: .systemBlue , placeHolder: "confirm_password".localized)
    }
    func onUserRegister( userEmail : String ,
                        userPassword : String ) {
        navigator?.showLoading()
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [self]authResult,error in
            navigator?.hideLoading()
            if let e = error {
                //fail
                navigator?.showAlert(title : "RegistrationـStatus".localized ,message: "error".localized+" :\(e.localizedDescription)", onActionClick: nil)
            }else{
                //success
                guard let result = authResult else{return}
                navigator?.showAlert(title : "RegistrationـStatus".localized ,message: "SuccessfullyـRegistered".localized, onActionClick: { [self] in
                    registerNavigator?.goToUserDetails(result: result)
                    
                })
                
            }
        }
    }
    func Validate() -> Bool{
        isValid = true
        if let userName = userDataInfo?.name , let userEmail = userDataInfo?.email,
            let userPassword = userDataInfo?.password , let userConfirmPassword = userDataInfo?.confirmPassword{
            if(userName.text!.isEmpty ){
                isValid = false
                navigator?.textFieldStyle(tf: userName, color: .red, placeHolder: "please_enter_your_name".localized)
            }else{
                isValid = true
                navigator?.textFieldStyle(tf: userName, color: .systemBlue, placeHolder: "user_name".localized)
            }
            if(userPassword.text!.isEmpty ){
                isValid = false
                navigator?.textFieldStyle(tf: userPassword, color: .red, placeHolder: "please_enter_your_password".localized)
            }else{
                isValid = true
                navigator?.textFieldStyle(tf: userPassword, color: .systemBlue, placeHolder: "password".localized)
            }
            if(userEmail.text!.isEmpty ){
                isValid = false
                navigator?.textFieldStyle(tf: userEmail, color: .red, placeHolder: "please_enter_your_email".localized)
            }else{
                isValid = true
                navigator?.textFieldStyle(tf: userEmail, color: .systemBlue, placeHolder: "email".localized)
            }
            
            if(userConfirmPassword.text!.isEmpty || userPassword.text != userConfirmPassword.text ){
                isValid = false
                navigator?.textFieldStyle(tf: userConfirmPassword, color: .red, placeHolder: "incorrect_password".localized)
            }else{
                isValid = true
                navigator?.textFieldStyle(tf: userConfirmPassword, color: .systemBlue, placeHolder: "confirm_password".localized)
            }
        }
        return isValid
    }
}
