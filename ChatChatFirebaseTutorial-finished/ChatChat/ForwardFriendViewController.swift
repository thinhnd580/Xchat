//
//  ForwardFriendViewController.swift
//  ChatChat
//
//  Created by ThinhND on 3/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

protocol ForwardFriendListVCDelegate {
    func didSelectUser(user:User);
}

class ForwardFriendViewController: UIViewController, FriendListVCDelegate {

    @IBOutlet weak var viewContainer: UIView!
    var delegate: ForwardFriendListVCDelegate?
    var friendListVC: FriendListViewController?
    var friends:[User] = []
    private var userRefHandle: FIRDatabaseHandle?
    private lazy var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child(Constants.FBDatabase.User)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.friendListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendListViewController") as? FriendListViewController
        self.friendListVC?.delegate = self
        self.observeUsers()
        self.addChildViewController(self.friendListVC!)
        self.friendListVC?.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview((self.friendListVC?.view)!)
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
        })
    }

    func didSelectAtIndex(index: Int) {
        self.dismiss(animated: true) { 
            self.delegate?.didSelectUser(user: self.friends[index])
        }
        
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
