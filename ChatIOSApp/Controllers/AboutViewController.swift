//
//  AboutViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 30/04/2023.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var chatApp: UILabel!
    
    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var version: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatApp.text = "chat_now_messenger".localized
        version.text = "version".localized
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        summary.layer.cornerRadius = 15
        summary.clipsToBounds = true
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
