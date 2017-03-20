//
//  FireBaseControl.swift
//  ChatChat
//
//  Created by ThinhND on 3/20/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class FireBaseControl: NSObject {
    
    private var channelRefHandle: FIRDatabaseHandle?
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child(Constants.FBDatabase.User)
    
    func createUser() {
        if let name = newChannelTextField?.text {
            let newChannelRef = channelRef.childByAutoId()
            let channelItem = [
                "name": name
            ]
            newChannelRef.setValue(channelItem)
        }    
    }

    func createChannel(_ sender: AnyObject) {
        if let name = newChannelTextField?.text {
            let newChannelRef = channelRef.childByAutoId()
            let channelItem = [
                "name": name
            ]
            newChannelRef.setValue(channelItem)
        }    
    }
    
}
