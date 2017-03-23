//
//  User.swift
//  ChatChat
//
//  Created by ThinhND on 3/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class User {
    var uid: String = ""
    var avatarUrl: String = ""
    var email: String = ""
    var name: String = ""
    var RSAPKey: String = ""
    var RSASKey: String = ""
    
    init() {
        
    }

    init(uid: String, name: String, avatarUrl: String, email: String,RSAPKey: String, RSASKey: String ) {
        self.uid = uid
        self.name = name
        self.avatarUrl = avatarUrl
        self.email = email
        self.RSAPKey = RSAPKey
        self.RSASKey = RSASKey
    }
}
