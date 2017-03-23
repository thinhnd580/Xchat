//
//  KeyChainControl.swift
//  ChatChat
//
//  Created by ThinhND on 3/22/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import KeychainAccess

class KeyChainControl: NSObject {
    
    static let keychain = Keychain(service: Constants.ConstantsString.bundleID)
    
    static func saveRSAKeyPair(pubKey: Data, priKey: Data) {
        keychain[data: Constants.ConstantsString.rsaPKey] = pubKey
        keychain[data: Constants.ConstantsString.rsaSKey] = priKey
    }
    
    static func savePRESENT128KEYForChannelID(channelID: String, key: String) {
        return keychain[string: channelID] = key
    }
    
    static func getPRESENT128KEYForChannelID(channelID: String) -> String {
        return try! keychain.getString(channelID)!
    }
    
    static func getRSAPublicKey() -> Data {
        return try! keychain.getData(Constants.ConstantsString.rsaPKey)!
    }
    
    static func getRSAPrivateKey() -> Data{
        return try! keychain.getData(Constants.ConstantsString.rsaSKey)!
    }
    
    static func clearRSAKey() {
        do {
            try keychain.remove(Constants.ConstantsString.rsaPKey)
            try keychain.remove(Constants.ConstantsString.rsaSKey)
        } catch let error {
            print("error: \(error)")
        }
    }
    
}
