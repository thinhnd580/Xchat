//
//  AppDelegate.swift
//  Book Phui
//
//  Created by ThinhND on 3/8/17.
//  Copyright © 2017 Half Bird. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.configUI()
        self.configSocialNetwork()
        
        
        
        return true
    }
    
    func configSocialNetwork() {
        FIRApp.configure()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
//        try? FIRAuth.auth()?.signOut()
        if (FIRAuth.auth()?.currentUser) != nil {
            self.presentMainScreen()
            print("\(FIRAuth.auth()?.currentUser?.email) + \(FIRAuth.auth()?.currentUser?.displayName) + \(FIRAuth.auth()?.currentUser?.photoURL)")
        } else {
            self.presentLoginScreen()
        }
        
        FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if FIRAuth.auth()?.currentUser != nil {
                self.presentMainScreen()
            } else {
                
                self.presentLoginScreen()
            }
        }
        
        
    }
    
    func configUI() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        UINavigationBar.appearance().barTintColor = UIColor(red: 36/255.0, green: 167/255.0, blue: 10/255.0, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-60, -60), for: .default)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if let error = error {
                // ...
                return
            }
            FireBaseControl.sharedInstance.createUser()
            self.presentMainScreen()
        }
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        self.presentLoginScreen()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any)  -> (Bool)
    {
        if url.scheme == "fb377920462578708" {
//            return FBSDKApplicationDelegate.sharedInstance().application(application,
//                                                                         open: url,
//                                                                         sourceApplication: sourceApplication,
//                                                                         annotation: annotation)
            return true
        }else{
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        }
    }
    
    // MARK: - Handle Present
    func presentLoginScreen() -> Void {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func presentMainScreen() -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()
        let channelVc = (initialViewController?.childViewControllers.first as! UITabBarController).viewControllers?.first as! ChannelListViewController
        channelVc.senderDisplayName = FIRAuth.auth()?.currentUser?.displayName!
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }

}

