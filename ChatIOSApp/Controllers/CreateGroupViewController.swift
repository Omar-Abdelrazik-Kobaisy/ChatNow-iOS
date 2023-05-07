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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel = CreateGroupViewModel()
        viewModel?.navigator = self
        viewModel?.createGroupInfo = (groupNameTF , groupDescTF , groupImage)
    } 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
