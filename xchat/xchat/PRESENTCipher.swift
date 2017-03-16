//
//  PRESENTCipher.swift
//  xchat
//
//  Created by ThinhND on 3/14/17.
//  Copyright © 2017 thjnh195. All rights reserved.
//

import UIKit

//      0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f
let Sbox:[Int64] = [0xc,0x5,0x6,0xb,0x9,0x0,0xa,0xd,0x3,0xe,0xf,0x8,0x4,0x7,0x1,0x2]
let Sbox_inv:[Int64] = [5, 14, 15, 8, 12, 1, 2, 13, 11, 4, 6, 3, 0, 7, 9, 10]
let PBox:[Int64] = [0,16,32,48,1,17,33,49,2,18,34,50,3,19,35,51,
                    4,20,36,52,5,21,37,53,6,22,38,54,7,23,39,55,
                    8,24,40,56,9,25,41,57,10,26,42,58,11,27,43,59,
                    12,28,44,60,13,29,45,61,14,30,46,62,15,31,47,63]
let PBox_inv:[Int64] = [0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63]

struct Int80 {
    var strKey : String
    init(str:String) {
        strKey = str.utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 2).pad(with: "0", toLength: 8) }
    }
    

    func extract64BitKey() -> Int64 {
        let index = self.strKey.index(self.strKey.startIndex, offsetBy: 64)
        return strtoll(self.strKey.substring(to: index), nil, 2)
    }
    
    mutating func getNextKeyAtRound(index: Int) {
        var newkey = ""
        
        //Shift key
        var startIndex = self.strKey.index(self.strKey.startIndex, offsetBy: 61)
        newkey.append(self.strKey.substring(from: startIndex))
        newkey.append(self.strKey.substring(to: startIndex))
        
        
        // SBox
        let inSBoxStr = newkey.substring(start: 0, end: 4)
        var x = Int(strtoll(inSBoxStr, nil, 2))
        let intOutSBox = Sbox[x]
        
        let outSBoxStr = String(intOutSBox, radix: 2).pad(with: "0", toLength: 4)
        
        startIndex = newkey.index(newkey.startIndex, offsetBy: 0)
        var toIndex = newkey.index(newkey.startIndex, offsetBy: 4)
        
        newkey = newkey.replacingCharacters(in: Range<String.Index>(uncheckedBounds: (lower: startIndex, upper: toIndex)), with: outSBoxStr)
        
        
        //XOR round counter
        
        let inXorStr = newkey.substring(start: 60, end: 65)
        x = Int(strtoll(inXorStr, nil, 2))
        let intOutXor = x ^ index
        
        let outXorStr = String(intOutXor, radix: 2).pad(with: "0", toLength: 5)
        
        startIndex = newkey.index(newkey.startIndex, offsetBy: 60)
        toIndex = newkey.index(newkey.startIndex, offsetBy: 65)
        newkey = newkey.replacingCharacters(in: Range<String.Index>(uncheckedBounds: (lower: startIndex, upper: toIndex)), with: outXorStr)
        
        self.strKey = newkey
    }
}

class PRESENTCipher: NSObject {
    
    let rounds:Int = 32
    var roundkeys:[Int64] = []
    
    init?(key:String?) {
        if let key = key {
            if key.characters.count * 8 == 80 {
                //80 bit
                
            } else if key.characters.count * 8 == 128 {
                //128 bit
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
    
    func generateRoundKey80Bit(key:String) -> [Int64] {
//        Generate the roundkeys for a 80-bit key
//        
//        Input:
//        key:    the key as a 80-bit integer
//        rounds: the number of rounds as an integer
//        Output: list of 64-bit roundkeys as integers
        
        var subKeys:[Int64] = []
        var keyInt80 = Int80.init(str: key)
        
        for i in 1...self.rounds {
            subKeys.append(keyInt80.extract64BitKey())
            
            keyInt80.getNextKeyAtRound(index: i)
        }
        return [12]
    }
    
    func stringToNumber(str:String) -> Int64 {
        let encode = str.utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 16, uppercase: false) }
        let intValue = strtoll(encode, nil, 16)
        return intValue
    }

}
