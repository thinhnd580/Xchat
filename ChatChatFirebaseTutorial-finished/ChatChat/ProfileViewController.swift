//
//  ProfileViewController.swift
//  ChatChat
//
//  Created by ThinhND on 4/3/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var imgAvatar: UIAvatar!
    @IBOutlet weak var lbUsername: UILabel!
    
    @IBOutlet weak var viewFriendList: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        let url = FIRAuth.auth()?.currentUser?.photoURL?.absoluteString
        self.imgAvatar.sd_setImage(with: URL.init(string: url!))
        self.lbUsername.text = FIRAuth.auth()?.currentUser?.displayName
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cellKeyClick(_ sender: Any) {
        let vc = self.tabBarController?.viewControllers?.first as! ChannelListViewController
        FireBaseControl.sharedInstance.deleteAllChannel(channels: vc.channels)
        try? FIRAuth.auth()?.signOut()
    }

    @IBAction func btnLogoutClick(_ sender: Any) {
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
