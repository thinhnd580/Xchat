//
//  ForwardFriendViewController.swift
//  ChatChat
//
//  Created by ThinhND on 3/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class ForwardFriendViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    var friendListVC: FriendListViewController?
    var friends:[AnyObject] = []
    private var userRefHandle: FIRDatabaseHandle?
    private lazy var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child(Constants.FBDatabase.User)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FriendListViewController") as? FriendListViewController
        self.observeUsers()
        self.addChildViewController(self.friendListVC!)
        self.friendListVC?.view.frame = self.viewContainer.bounds
        self.view.addSubview((self.friendListVC?.view)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func observeUsers() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        userRefHandle = userRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 {
                self.channels.append(Channel(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
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
