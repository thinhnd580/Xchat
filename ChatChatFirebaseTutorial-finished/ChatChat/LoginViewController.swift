//
//  LoginViewController.swift
//  Book Phui
//
//  Created by ThinhND on 3/9/17.
//  Copyright © 2017 Half Bird. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import NVActivityIndicatorView

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    
    
    var activityIndicatorView : NVActivityIndicatorView!

//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        
//        print("\(result)")
//        if (error == nil) {
//            if !result.isCancelled {
//                let credential = FIRFacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
//                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
//                    // ...
//                    if let error = error {
//                        // ...
//                        return
//                    }
//                    self.activityIndicatorView.stopAnimating()
//                }
//                
//            }
//        }
//    }
//    
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
//        self.btnFBLogin = FBSDKLoginButton()
//        self.btnFBLogin.readPermissions = ["public_profile", "email", "user_friends"];
//        self.btnFBLogin.delegate = self;
        // Do any additional setup after loading the view.
        
        self.activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.size.width/2 - 50, y: self.view.bounds.size.height/2 - 50, width: 100, height: 100))
        self.activityIndicatorView.center = self.view.center
        self.view.addSubview(self.activityIndicatorView)
//        self.activityIndicatorView.startAnimating()
    }
    
    @IBAction func btnLoginFBClick(_ sender: Any) {
        //TODO : show loading
//        self.btnFBLogin.sendActions(for: .touchUpInside)
        self.activityIndicatorView.startAnimating()
    }
    
    @IBAction func btnLoginGGClick(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
