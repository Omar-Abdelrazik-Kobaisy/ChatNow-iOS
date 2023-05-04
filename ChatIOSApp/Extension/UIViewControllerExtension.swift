//
//  UIViewControllerExtension.swift
//  ChatIOSApp
//
//  Created by Omar on 19/04/2023.
//

import UIKit

extension UIViewController {
    /// this add a child controller to the view of another controller
    func addAsChildViewController(type controller: UIViewController, attached toView: UIView) {
        
        // Add Child View Controller
        addChild(controller)
        
        // Add Child View as Subview
        toView.addSubview(controller.view)
        
        // Configure Child View
        controller.view.frame = toView.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        controller.didMove(toParent: self)
        
    }
}
