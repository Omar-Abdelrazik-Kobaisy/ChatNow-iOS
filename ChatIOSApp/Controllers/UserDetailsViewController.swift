//
//  UserDetailsViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 13/04/2023.
//

import UIKit
import Firebase
import FirebaseAuth

class UserDetailsViewController: BaseViewController  {

    
    
    var userResult : AuthDataResult? = nil
    var userDetailsViewModel : UserDetailsViewModel?
    var userImageURL : String?
    var userImageRef : String?
    var username : String?

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userAbout: UITextField!
    
    @IBOutlet weak var getStartedBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        userName.text = username
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        StorageUtils.sharedInstance.navigator = self
        userDetailsViewModel = UserDetailsViewModel()
        userDetailsViewModel?.userDetailsNavigator = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        name.text = "name".localized
        about.text = "about".localized
        getStartedBtn.titleLabel?.text = "get_started".localized
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true)
        }else{
            //camera
        }
    }
    
    
    @IBAction func getStarted(_ sender: UIButton) {
        if userResult?.user != nil {
            insertUserToDataBase(userId: userResult?.user.uid ?? "")
        }
    }
    
    
    
    func insertUserToDataBase(userId : String){
        let user = User(id: userId , userName: userName.text , email: userResult?.user.email , image: userImageURL ?? "NoImage", about: userAbout.text , imageRef: userImageRef )
        userDetailsViewModel?.inserUserToDataBase(user: user)
    }
    

}

extension UserDetailsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        userImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        userImage.image = image
        guard let imageData = image.pngData() else { return}
        guard let userEmail = userResult?.user.email  else {return}
        userDetailsViewModel?.insertImageToDataBase(imageData: imageData, userEmail: userEmail)
        userDetailsViewModel?.bindingImageURL = {[weak self]imgURL in
            self?.userImageURL = imgURL
            print(self?.userImageURL ?? "")
        }
        userDetailsViewModel?.bindingImageRef = {[weak self]imgREF in
            self?.userImageRef = imgREF
            print(self?.userImageRef ?? "")
        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        userImage.image = UIImage(named: "1")
        self.dismiss(animated: true)
    }
    
}
extension UserDetailsViewController : UserDetailsNavigator{
    func navigateToHomeVC() {
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
