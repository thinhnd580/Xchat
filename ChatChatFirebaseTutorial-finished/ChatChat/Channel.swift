//
//  User.swift
//  ChatChat
//
//  Created by ThinhND on 3/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//
import UIKit

class Channel {
    var id: String = ""
    var name: String = ""
    var initKey: String = ""
    var user1: User? = nil
    var user2: User? = nil
    
    init() {
        
    }
    
    init(id: String, name: String, initKey: String, user1: User, user2: User) {
        self.id = id
        self.name = name
        self.initKey = initKey
        self.user1 = user1
        self.user2 = user2
    }
}
