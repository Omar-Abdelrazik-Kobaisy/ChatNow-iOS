//
//  SettingsViewController.swift
//  ChatIOSApp
//
//  Created by Omar on 21/04/2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorageUI
import MOLH
class SettingsViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var userAbout: UITextField!
    
    @IBOutlet weak var AppLanguageBTN: UIButton!
    
    @IBOutlet weak var appTheme: UILabel!
    
    @IBOutlet weak var aboutApp: UIButton!
    
    @IBOutlet weak var userID: UITextField!
    
    @IBOutlet weak var themeSwitcher: UISegmentedControl!
    
    @IBOutlet weak var bg: UIImageView!
    var settingsViewModel : SettingsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UserDefaults.standard.bool(forKey: "Theme") {
            themeSwitcher.selectedSegmentIndex = 1
        }else{
            themeSwitcher.selectedSegmentIndex = 0
        }
        
        if let imageREF = StorageUtils.sharedInstance.storageReference?.child(UserProvider.getInstance.getCurrentUser()?.imageRef ?? "") {
            userImage.sd_setImage(with: imageREF, placeholderImage: UIImage(named: "1"))
        } else{
            print(" error in loading image in setting ")
        }
        
        userImage.layer.cornerRadius = 15
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.borderWidth = 2
        userName.text = UserProvider.getInstance.getCurrentUser()?.userName
        
        userAbout.text = UserProvider.getInstance.getCurrentUser()?.about
        
        userID.text = UserProvider.getInstance.getCurrentUser()?.id
        
        settingsViewModel = SettingsViewModel(settingsViewModelDelegate: self)
        var menuActions : [UIAction] = []
        _ = settingsViewModel?.menuItems.map{menuItem in
            let menuAction = UIAction(title: menuItem.title ?? "" ,image: menuItem.image) { action in
                menuItem.MenuItemAction()
            }
            menuActions.append(menuAction)
        }
        
        let menu = UIMenu(options: .displayInline , children: menuActions)
       
        AppLanguageBTN.menu = menu
        AppLanguageBTN.showsMenuAsPrimaryAction = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppLanguageBTN.titleLabel?.text = "app_language".localized
        appTheme.text = "app_theme".localized
        aboutApp.titleLabel?.text = "about_app".localized
    }
    
    @IBAction func onThemeSwitch(_ sender: UISegmentedControl) {
        
        let scenes = UIApplication.shared.connectedScenes.map{
            $0 as? UIWindowScene
        }
        
        _ = scenes.map{
            $0?.windows.forEach { window in
                if sender.selectedSegmentIndex == 1 {
                    window.overrideUserInterfaceStyle = .light
                    UserDefaults.standard.set(true, forKey: "Theme")
                }else{
                    window.overrideUserInterfaceStyle = .dark
                    UserDefaults.standard.set(false, forKey: "Theme")
                }
            }
        }
    }
    
    @IBAction func onAboutAppBTN(_ sender: Any) {
        let aboutVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        self.navigationController?.pushViewController(aboutVC, animated: true)
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
extension SettingsViewController : SettingsViewModelDelegate{
    func onArabicItemSelected() {
        print("arabic selected")
        if MOLHLanguage.currentAppleLanguage() == "en"{
            MOLH.setLanguageTo("ar")
            MOLH.reset(transition: .transitionFlipFromLeft)
        }else{
            print("language is arabic")
        }
    }
    
    func onEnglishItemSelected() {
        print("english selected")
        if MOLHLanguage.currentAppleLanguage() == "ar"{
            MOLH.setLanguageTo("en")
            MOLH.reset()
        }else{
            print("language is english")
        }
    }
    
    
}
