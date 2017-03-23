/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase

enum Section: Int {
  case createNewChannelSection = 0
  case currentChannelsSection
}

class ChannelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ForwardFriendListVCDelegate {

  // MARK: Properties
  var senderDisplayName: String?
  var newChannelTextField: UITextField?
  
    @IBOutlet weak var tableView: UITableView!
  private var channelRefHandle: FIRDatabaseHandle?
  private var channels: [Channel] = []
  
  private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(1024)
//    let content = "fuck u"
//    let en = Cryptography.encryptWithRSAKey(key: publicKey, content: content)
//    let de = Cryptography.decryptWithRSAKey(key: privateKey, content: en)
//    
//    let x = "cái gì cơ"
//    let en = Cryptography.encryptMessage(message: x, PRESENTKey: "1234567890123456")
//    let de = Cryptography.decryptMessage(message: en, PRESENTKey: "1234567890123456")
    
    
    title = "RW RIC"
    self.tableView.register(UINib(nibName: "ChannelCell", bundle: nil), forCellReuseIdentifier: "ChannelCell")
    observeChannels()
    self.tableView.dataSource = self
    self.tableView.delegate = self
    
  }
  
  deinit {
    if let refHandle = channelRefHandle {
      channelRef.removeObserver(withHandle: refHandle)
    }
  }
  
  // MARK :Actions
  
    func createChannel(withUser: User) {
        let newChannelRef = channelRef.childByAutoId()
        let newChannelId = Util.randomString(length: 16)
        let channelItem = [
            "id" : newChannelId,
            "user1" : [
                "name": (FIRAuth.auth()?.currentUser?.displayName)!,
                "uid" : (FIRAuth.auth()?.currentUser?.uid)! ,
                "avatarUrl": (FIRAuth.auth()?.currentUser?.photoURL?.absoluteString)! 
            ],
            "user2" : [
                "name": withUser.name,
                "uid" : withUser.uid ,
                "avatarUrl": withUser.avatarUrl
            ],
            "initKey" : self.genChannelInit(channelId: newChannelId, rsaKeyPEM: withUser.RSAPKey),
            "name" : withUser.name
        ] as [String : Any]
        newChannelRef.setValue(channelItem)
    }
    
    func genChannelInit(channelId : String, rsaKeyPEM: String) -> String {
        //gen PRESENT 128 bit key
        let PRESENTKEY = Util.randomString(length: 16)
        //Save to keychain
        KeyChainControl.savePRESENT128KEYForChannelID(channelID: channelId, key: PRESENTKEY)
        //Encrypt with RSA Key
        
        let publicKeyDER = try! SwKeyConvert.PublicKey.pemToPKCS1DER(rsaKeyPEM)
        
        return Cryptography.encryptWithRSAKey(key: publicKeyDER, content: PRESENTKEY)
    }
  
    @IBAction func btnAddChannelClick(_ sender: Any) {
        self.performSegue(withIdentifier: "ChoseFriendSegue", sender: nil)
    }

    @IBAction func btnLogoutClick(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
    }
    
  // MARK: Firebase related methods

  private func observeChannels() {
    // We can use the observe method to listen for new
    // channels being written to the Firebase DB
    channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
      let channelData = snapshot.value as! Dictionary<String, AnyObject>
      
      if let name = channelData["name"] as! String!, name.characters.count > 0 {
        
        let dict = channelData
        
        let newChannel = Channel()
        newChannel.id = Util.nonNullStrong(str: dict["id"] as? String!)
        
        newChannel.initKey = Util.nonNullStrong(str: dict["initKey"] as! String!)
        
        let user1Dic = channelData["user1"] as! [String: String]
        let user1 = User()
        user1.name = user1Dic["name"]!
        user1.avatarUrl = user1Dic["avatarUrl"]!
        user1.uid = user1Dic["uid"]!
        
        let user2Dic = channelData["user2"] as! [String: String]
        let user2 = User()
        user2.name = user2Dic["name"]!
        user2.avatarUrl = user2Dic["avatarUrl"]!
        user2.uid = user2Dic["uid"]!
        
        if user1.name == FIRAuth.auth()?.currentUser?.displayName {
            newChannel.name = user2.name
        } else if user2.name == FIRAuth.auth()?.currentUser?.displayName {
            newChannel.name = user1.name
        } else {
            return
        }
        
        newChannel.user1 = user1
        newChannel.user2 = user2
        self.channels.append(newChannel)
        self.tableView.reloadData()
      } else {
        print("Error! Could not decode channel data")
      }
    })
  }

    // MARK: ForwardFriendDelegate
    func didSelectUser(user: User) {
        self.createChannel(withUser: user)
    }
  
  // MARK: Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let id = segue.identifier, id == "ChoseFriendSegue" {
        let vc = segue.destination as! ForwardFriendViewController
        vc.delegate = self
    } else {
        if let channel = sender as? Channel {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
        }
    }
    
  }
  
  // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as! ChannelCell
        let channel = channels[(indexPath as NSIndexPath).row]
        if channel.user1?.name == FIRAuth.auth()?.currentUser?.displayName {
            cell.imgAvatar.sd_setImage(with: URL.init(string: (channel.user1?.avatarUrl)!))
        } else if channel.user2?.name == FIRAuth.auth()?.currentUser?.displayName {
            cell.imgAvatar.sd_setImage(with: URL.init(string: (channel.user2?.avatarUrl)!))
        }
        cell.lbTitle.text = channel.name
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
            let channel = channels[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "ShowChannel", sender: channel)
//        }
    }

}
