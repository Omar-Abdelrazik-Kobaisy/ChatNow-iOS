//
//  FriendDetailsViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 07/05/2023.
//

import UIKit

class FriendDetailsViewController: UIViewController {

    var friend : User?
    @IBOutlet weak var friendImag: UIImageView!
    
    @IBOutlet weak var friendName: UILabel!
    
    @IBOutlet weak var friendAbout: UILabel!
    
    @IBOutlet weak var friendID: UILabel!
    
    @IBOutlet weak var bg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        friendImag.layer.cornerRadius = 15
        friendImag.layer.borderColor = UIColor.white.cgColor
        friendImag.layer.borderWidth = 2
        if let imageREF = StorageUtils.sharedInstance.storageReference?.child(friend?.imageRef ?? "") {
            friendImag?.sd_setImage(with: imageREF, placeholderImage: UIImage(named: "1"))
        } else{
            print(" error in loading image in setting ")
        }
        
        friendID.text = friend?.id
        friendName.text = friend?.userName
        friendAbout.text = friend?.about
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
