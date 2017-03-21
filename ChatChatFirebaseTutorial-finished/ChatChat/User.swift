//
//  User.swift
//  ChatChat
//
//  Created by ThinhND on 3/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

internal class User: NSObject {
    internal let uid: String
    internal let avatarUrl: String
    internal let email: String
    internal let name: String
    internal let RSAPKey: String
    internal let RSASKey: String
    
    init(uid: String, name: String, avatarUrl: String, email: String,RSAPKey: String, RSASKey: String ) {
        self.uid = uid
        self.name = name
        self.avatarUrl = avatarUrl
        self.email = email
        self.RSAPKey = RSAPKey
        self.RSASKey = RSASKey
    }
}
