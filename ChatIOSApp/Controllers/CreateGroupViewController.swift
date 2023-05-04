//
//  CreateGroupViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 21/04/2023.
//

import UIKit

class CreateGroupViewController: BaseViewController {

    @IBOutlet weak var groupNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFieldStyle(tf: groupNameTF, color: .systemBlue, placeHolder: "enter")
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
