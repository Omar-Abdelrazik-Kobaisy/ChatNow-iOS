//
//  CreateGroupViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 21/04/2023.
//

import UIKit

class CreateGroupViewController: BaseViewController {

    @IBOutlet weak var groupNameTF: UITextField!
    
    @IBOutlet weak var groupDescTF: UITextField!
    
    @IBOutlet weak var groupImage: UIImageView!
    var viewModel : CreateGroupViewModel?
//    var loadGroupChat : ReloadGroups?
    var groupImageURL : String?
    var groupImageRef : String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = CreateGroupViewModel()
        viewModel?.navigator = self
        viewModel?.createGroupInfo = (groupNameTF , groupDescTF , groupImage , groupImageRef)
        viewModel?.configureUI()
        viewModel?.bindingImageRef = {[weak self] imgREF in
            self?.groupImageRef = imgREF
        }
        viewModel?.bindingImageURL = {[weak self] imgURL in
            self?.groupImageURL = imgURL
        }
    } 
    

   
    @IBAction func chooseImage(_ sender: UIButton) {
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
    
    
    @IBAction func onAddGroupBtn(_ sender: UIButton) {
        guard let currentUser = UserProvider.getInstance.getCurrentUser() else { return }
        let group = Group(name: groupNameTF.text , imageREF:groupImageRef  , description:groupDescTF.text , users: [currentUser])
        viewModel?.onAddGroup(group)
    }
    
}
extension CreateGroupViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        groupImage.image = image
        guard let imageData = image.pngData() else{ return }
        viewModel?.insertImageToDB(imgData: imageData)
        viewModel?.bindingImageRef = {[weak self] imgREF in
            self?.groupImageRef = imgREF
        }
        viewModel?.bindingImageURL = {[weak self] imgURL in
            self?.groupImageURL = imgURL
        }
        self.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
