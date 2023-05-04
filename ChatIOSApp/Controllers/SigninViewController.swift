//
//  ViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 11/04/2023.
//

import UIKit


class SinginViewController: BaseViewController  {


    var viewModel : SigninViewModel? 

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var createAccBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SigninViewModel()
        viewModel?.navigator = self
        viewModel?.signinNavigator = self
        viewModel?.userDataInfo = (email , password)
        viewModel?.configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "sign_in".localized
//        createAccBtn.currentTitle?.localized
//        logInBtn.currentTitle?.localized
        createAccBtn.titleLabel?.text = "create_an_account".localized
        logInBtn.titleLabel?.text = "log_in".localized
        
    }
    
    @IBAction func logIn(_ sender: Any) {
        if(!viewModel!.Validate())
        {
            return
        }
        guard let email = email.text , let password = password.text else {return}
        viewModel?.onUserSignin(email: email, password: password)

    }

}
extension SinginViewController : SigninNavigator {
    func goToHome() {
        
            let ContainerVC = self.storyboard?.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
            let splitView = self.storyboard?.instantiateViewController(withIdentifier: "SplitViewController") as! SplitViewController // ===> Your splitViewController
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.navigationController?.pushViewController(homeVC, animated: true)
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationBar.tintColor = .white 
        }else{
            ContainerVC.addAsChildViewController(type: splitView, attached: ContainerVC.view)
            ContainerVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(ContainerVC, animated: true)
            }
    }
}

