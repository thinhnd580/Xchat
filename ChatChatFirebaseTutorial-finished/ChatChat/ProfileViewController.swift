//
//  ProfileViewController.swift
//  ChatChat
//
//  Created by ThinhND on 4/3/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, FriendListVCDelegate {

    @IBOutlet weak var contraintFriendListHeight: NSLayoutConstraint!
    @IBOutlet weak var imgAvatar: UIAvatar!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var viewFriendList: UIView!
    @IBOutlet weak var lbEmail: UILabel!
    var friendListVC: FriendListViewController?
    var friends:[User] = []
    private var userRefHandle: FIRDatabaseHandle?
    private lazy var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child(Constants.FBDatabase.User)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        let url = FIRAuth.auth()?.currentUser?.photoURL?.absoluteString
        self.imgAvatar.sd_setImage(with: URL.init(string: url!))
        self.lbUsername.text = FIRAuth.auth()?.currentUser?.displayName
        self.lbEmail.text = FIRAuth.auth()?.currentUser?.email
        
        self.friendListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendListViewController") as? FriendListViewController
        self.friendListVC?.delegate = self
        self.observeUsers()
        self.addChildViewController(self.friendListVC!)
        self.friendListVC?.view.frame = self.viewFriendList.bounds
        self.viewFriendList.addSubview((self.friendListVC?.view)!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func observeUsers() {
        // We can use the observe method to listen for new
        // users being written to the Firebase DB
        userRefHandle = userRef.observe(.childAdded, with: { (snapshot) -> Void in
            let userData = snapshot.value as! Dictionary<String, AnyObject>
            
            if let uid = userData["uid"] as? String, uid == FIRAuth.auth()?.currentUser?.email {
                return
            }
            let user = User()
            user.uid = Util.nonNullStrong(str: userData["uid"] as? String)
            user.email = Util.nonNullStrong(str: userData["email"] as? String)
            user.avatarUrl = Util.nonNullStrong(str: userData["avatarUrl"] as? String)
            user.name = Util.nonNullStrong(str: userData["name"] as? String)
            user.RSAPKey = Util.nonNullStrong(str: userData["RSAPKey"] as? String)
            self.friends.append(user)
            self.friendListVC?.loadTableData(data: self.friends)
            self.contraintFriendListHeight.constant = (self.friendListVC?.tableView.contentSize.height)! + 40;
        })
    }

    @IBAction func cellKeyClick(_ sender: Any) {
        
    }
    
    func didSelectAtIndex(index: Int) {
    }

    @IBAction func btnLogoutClick(_ sender: Any) {
        let vc = self.tabBarController?.viewControllers?.first as! ChannelListViewController
        FireBaseControl.sharedInstance.deleteAllChannel(channels: vc.channels)
        try? FIRAuth.auth()?.signOut()
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
