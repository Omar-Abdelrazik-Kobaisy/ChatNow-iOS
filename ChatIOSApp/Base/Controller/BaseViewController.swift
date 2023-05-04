//
//  BaseViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 17/04/2023.
//

import UIKit

class BaseViewController: UIViewController {


    let activityView = UIActivityIndicatorView(style: .large)
    let fadeView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFadeView(fadeView: fadeView)
        // Do any additional setup after loading the view.
    }
    
    
    
    

}
extension BaseViewController : BaseNavigator {
    
    
    fileprivate func initializeFadeView(fadeView : UIView) {
        // Do any additional setup after loading the view.
        
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = UIColor.systemGray5
        fadeView.alpha = 0.3
    }
    
        func textFieldStyle(tf:UITextField! , color : UIColor , placeHolder : String)
        {
            tf.placeholder = placeHolder
            tf.layer.shadowOpacity = 0.3
            tf.layer.cornerRadius = 25.0
            tf.layer.borderWidth = 2.0
            tf.layer.borderColor = color.cgColor
            tf.layer.masksToBounds = true
        }
     func showLoading(){
         self.view.addSubview(fadeView)

         self.view.addSubview(activityView)
         activityView.hidesWhenStopped = true
         activityView.center = self.view.center
         activityView.startAnimating()
     }
     
     func hideLoading(){
         fadeView.removeFromSuperview()
         activityView.stopAnimating()
     }
     
        func showAlert(title : String ,message:String , onActionClick: (() -> ())? ){
            let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default , handler: { action in
                if onActionClick == nil {
                    alert.dismiss(animated: true)
                }else{
                    onActionClick!()
                }
            }))
            self.present(alert, animated: true)
        }
}
