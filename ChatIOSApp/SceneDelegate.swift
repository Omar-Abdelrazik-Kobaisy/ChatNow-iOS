//
//  SceneDelegate.swift
//  ChatIOSApp
//
//  Created by Omar on 11/04/2023.
//

import UIKit
import MOLH
import FirebaseCore
import FirebaseAuth
import Firebase
class SceneDelegate: UIResponder, UIWindowSceneDelegate , MOLHSceneResetable{
    
    
    
    

    var window: UIWindow?

// my comment
//    This is the first method called in UISceneSession life cycle. This method will creates new UIWindow, sets the root view controller and makes this window the key window to be displayed.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        if (UserDefaults.standard.string(forKey: "user") != nil) {
//            // navigate to Home
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let ContainerVC = storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
//            let splitView = storyboard.instantiateViewController(withIdentifier: "SplitViewController") as! SplitViewController // ===> Your splitViewController
//            ContainerVC.addAsChildViewController(type: splitView, attached: ContainerVC.view)
//            window?.rootViewController = ContainerVC
//            window?.makeKeyAndVisible()
//        }
        
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        didStartView()
    }
    func reset(scene: UIScene) {
        didStartView()
    }
    
    func reset() {
        didStartView()
    }

    func didStartView(){
        if Auth.auth().currentUser != nil && UserProvider.getInstance.getCurrentUser() != nil{
            // navigate to Home
            print(Auth.auth().currentUser?.email ?? "")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ContainerVC = storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as! ContainerViewController
            let splitView = storyboard.instantiateViewController(withIdentifier: "SplitViewController") as! SplitViewController // ===> Your splitViewController
            
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController

        if UIDevice.current.userInterfaceIdiom == .phone
        {
            let navigationController = UINavigationController(rootViewController: homeVC)
            navigationController.navigationBar.prefersLargeTitles = false
            navigationController.navigationBar.tintColor = .white
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }else{
            ContainerVC.addAsChildViewController(type: splitView, attached: ContainerVC.view)
            window?.rootViewController = UINavigationController(rootViewController: ContainerVC)
            window?.makeKeyAndVisible()
            }
            
            
        }else {
            // navigate to SignIn
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let SignInVC = storyboard.instantiateViewController(withIdentifier: "SinginViewController") as! SinginViewController
            let navigationController = UINavigationController(rootViewController: SignInVC)
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

