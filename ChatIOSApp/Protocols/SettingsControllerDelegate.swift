//
//  SettingsControllerDelegate.swift
//  ChatIOSApp
//
//  Created by Omar on 02/05/2023.
//

import Foundation

protocol SettingsMenuNavigator {
    func ArabicItemSelected()
    func EnglishItemSelected()
}
protocol SettingsViewModelDelegate {
    func onArabicItemSelected()
    func onEnglishItemSelected()
}
