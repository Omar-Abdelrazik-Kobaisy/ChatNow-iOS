//
//  RegisterViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 11/04/2023.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: BaseViewController{


    var viewModel : RegisterViewModel?

    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField! 
    
    @IBOutlet weak var userConfirmPassword: UITextField!
    
    
    @IBOutlet weak var registerBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RegisterViewModel()
        viewModel?.userDataInfo = (userName , userEmail , userPassword , userConfirmPassword)
        viewModel?.navigator = self
        viewModel?.registerNavigator = self
        viewModel?.configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "register".localized
        registerBtn.titleLabel?.text = "register".localized
    }
    
    @IBAction func register(_ sender: Any) {
        
        if(!viewModel!.Validate()){
            return
        }
        guard let email = userEmail.text , let password = userPassword.text else{return}
        viewModel?.onUserRegister(userEmail: email, userPassword: password)
    }

}

extension RegisterViewController : RegisterNavigator {
    func goToUserDetails(result: AuthDataResult) {
        performSegue(withIdentifier: "UserDetails", sender: result)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let userDetailsViewController = segue.destination as! UserDetailsViewController
        userDetailsViewController.userResult = sender as? AuthDataResult
        userDetailsViewController.username = userName.text
        segue.destination.navigationItem.backBarButtonItem = nil
        segue.destination.navigationItem.leftBarButtonItem = nil
        segue.destination.navigationItem.hidesBackButton = true
        segue.destination.navigationItem.title = ""
    }
    
}
