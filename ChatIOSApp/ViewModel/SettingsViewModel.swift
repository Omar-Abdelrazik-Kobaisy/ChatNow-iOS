//
//  SettingsViewModel.swift
//  ChatIOSApp
//
//  Created by Omar on 30/04/2023.
//

import Foundation
import UIKit
class SettingsViewModel {
    
    
    var menuItems : [MenuItem] = []
    var settingsViewModelDelegate : SettingsViewModelDelegate?
    
    init(settingsViewModelDelegate : SettingsViewModelDelegate? = nil){
        self.settingsViewModelDelegate = settingsViewModelDelegate
        let arabicItem = ArabicItem(title: "Arabic" , image: UIImage(named: "arabic"), settingsNavigator: self  )
        let englishItem = EnglishItem(title: "English" , image: UIImage(named: "english") , settingsNavigator: self)
        
        
        menuItems.append(contentsOf: [arabicItem , englishItem])
    }
}
extension SettingsViewModel : SettingsMenuNavigator {
    func ArabicItemSelected() {
        settingsViewModelDelegate?.onArabicItemSelected()
    }
    
    func EnglishItemSelected() {
        settingsViewModelDelegate?.onEnglishItemSelected()
    }
    
}

