//
//  Cryptography.swift
//  ChatChat
//
//  Created by ThinhND on 3/22/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class Cryptography: NSObject {
    
    static func encryptWithRSAKey(key: Data, content: String) -> String {
        return (try! CC.RSA.encrypt(content.data(using: .utf8)!, derKey: key, tag: "".data(using: String.Encoding.utf8)!, padding: .oaep, digest: .sha1)).base64EncodedString()
    }
    
    static func decryptWithRSAKey(key: Data, content: String) -> String {
        let data = Data.init(base64Encoded: content)
        let (decrypt, _ ) = (try! CC.RSA.decrypt(data!, derKey: key, tag: "".data(using: String.Encoding.utf8)!, padding: .oaep, digest: .sha1))
        
        return String(data: decrypt, encoding: .utf8)!
        
    }
    
    static func encryptMessage(message: String, PRESENTKey: String) -> String {

        //Input : unicode string, length whatever
        //output : heximal string
        var encryptedMessage = ""
        var paddedMessage = ""
        
        
        let presentCipher = PRESENTCipher(key: PRESENTKey)
        
        
        let x = "2067c3ac"
        let en = presentCipher?.encrypt(block: x)
        let de = presentCipher?.decrypt(block: en!)
        
        let encodedMessage = Util.toHexStr(str: message)
        paddedMessage = encodedMessage
//        let decode = Util.hexStringtoAscii(encodedMessage)
        var numOfBlock = encodedMessage.characters.count / 8;
        let restLength = encodedMessage.characters.count % 8;
        if restLength > 0 {
            numOfBlock += 1;
            for _ in restLength...7 {
                paddedMessage += "00"
            }
        }
        
        for i in 0...numOfBlock - 1 {
            let subStr = paddedMessage.substring(start: i*8, end: i*8 + 8)
            encryptedMessage += (presentCipher?.encrypt(block: subStr))!
        }
        
        return encryptedMessage
    }
    
    static func decryptMessage(message: String, PRESENTKey: String) -> String {
        
        let presentCipher = PRESENTCipher(key: PRESENTKey)
        
        var decryptedMessage = ""
        let numOfBlock = message.characters.count / 16;
        
        for i in 0...numOfBlock-1 {
            let subStr = message.substring(start: i*16, end: i*16 + 16)
            let decryptedBlock = (presentCipher?.decrypt(block: subStr))!
            
            if i == numOfBlock-1, decryptedBlock.hasSuffix("00") {
                var decryptedBlockHex = Util.toHexStr(str: decryptedBlock)
                decryptedBlockHex = decryptedBlockHex.replacingOccurrences(of: "00", with: "")
                decryptedMessage += Util.hexStringtoAscii(decryptedBlockHex)
            } else {
                decryptedMessage += decryptedBlock
            }
        }
        // From decryptedMessage decode hex
        
        return Util.hexStringtoAscii(decryptedMessage)
    }
}
