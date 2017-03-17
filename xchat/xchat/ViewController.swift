//
//  ViewController.swift
//  xchat
//
//  Created by ThinhND on 3/14/17.
//  Copyright © 2017 thjnh195. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let test = String("a".data(using: .ascii), radix:16)
//        let baseStr = "asdasdasd"
//        let encode = baseStr.utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 16, uppercase: false) }
//        let x = Int64(encode, radix: 16) // Convert from Hex string
        let present = PRESENTCipher(key: "1234567890")
        let cipherText = present?.encrypt(block: "abcd1234")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

