//
//  FireBaseControl.swift
//  ChatChat
//
//  Created by ThinhND on 3/20/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase
import SwiftyRSA

class FireBaseControl: NSObject {
    
    static let sharedInstance = FireBaseControl()
    private var userRefHandle: FIRDatabaseHandle?
    private lazy var userRef: FIRDatabaseReference = FIRDatabase.database().reference().child(Constants.FBDatabase.User)
    
    func createUser() {
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(1024)
//        let privateKeyPEM = try! SwKeyConvert.PrivateKey.derToPKCS1PEM(privateKey)
        let publicKeyPEM = SwKeyConvert.PublicKey.derToPKCS8PEM(publicKey)
        let avatarUrl : String!
        if let url = FIRAuth.auth()?.currentUser?.photoURL?.absoluteString {
            avatarUrl = url
        } else {
            avatarUrl = ""
        }
        let user = [
            "uid": FIRAuth.auth()?.currentUser?.email ?? "",
            "email": FIRAuth.auth()?.currentUser?.email ?? "",
            "name": FIRAuth.auth()?.currentUser?.displayName ?? "",
            "avatarUrl": avatarUrl,
            "RSAPKey": publicKeyPEM,
            "friendListID": "asdasd"
            ] as [String : Any]
        self.userRef.child(uid).setValue(user)
        
        KeyChainControl.saveRSAKeyPair(pubKey: publicKey, priKey: privateKey)
        
    }

    func deleteAllChannel(channels: [Channel]) {
        let channelRef = FIRDatabase.database().reference().child(Constants.FBDatabase.Channel)
        for channel in channels {
            channelRef.child(channel.id).removeValue()
        }
    }
    
}
