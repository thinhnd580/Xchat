//
//  Util.swift
//  Book Phui
//
//  Created by Thanh Tran on 3/11/17.
//  Copyright © 2017 Half Bird. All rights reserved.
//

import Foundation

class Util {
    static func readTextFile(name: String, type: String = "") -> String {
        if let filepath = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // file not found!
        }
        return ""
    }
    
    static func readFile(name: String, type: String = "") -> Data? {
        if let url = Bundle.main.url(forResource: name, withExtension: type) {
            
            let data = try? Data(contentsOf: url)
            return data
        } else {
            // file not found!
        }
        return nil
    }
    
    static func delay(_ delay: Double, _ function: @escaping (() -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
            function()
        })
    }
    
    static func nonNullStrong(str:String?) -> String {
        if let str = str {
            return str
            
        } else {
            return ""
        }
    }
    
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    static func toHexStr(str: String) -> String {
        return str.utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 16)}
    }
    
    static func hexStringtoAscii(_ hexString : String) -> String {
        
        var hex = hexString
        var data = Data()
        while(hex.characters.count > 0) {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return String(data: data, encoding: .utf8)!
        
        
        
        
        
        var chars = [Character]()
        
        for c in hexString.characters
        {
            chars.append(c)
        }
        
        let numbers =  stride(from: 0, to: chars.count, by: 2).map{
            strtoul(String(chars[$0 ..< $0+2]), nil, 16)
        }
        
        var final = ""
        var i = 0
        
        while i < numbers.count {
            final.append(Character(UnicodeScalar(Int(numbers[i]))!))
            i += 1
        }
        
        return final
    }

}

extension String {
    
}

