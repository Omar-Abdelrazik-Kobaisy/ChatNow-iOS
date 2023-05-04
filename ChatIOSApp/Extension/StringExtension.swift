//
//  StringExtension.swift
//  ChatIOSApp
//
//  Created by Omar on 18/04/2023.
//

import Foundation

extension String {

    var localized : String {
        return NSLocalizedString(self, comment: "")
    }
    
    func isEmptyOrBlanck() -> Bool{
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return trimmed.isEmpty
    }
    
    
}
