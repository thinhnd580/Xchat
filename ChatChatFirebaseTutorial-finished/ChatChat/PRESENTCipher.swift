//
//  PRESENTCipher.swift
//  xchat
//
//  Created by ThinhND on 3/14/17.
//  Copyright © 2017 thjnh195. All rights reserved.
//

import UIKit

//      0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f
let Sbox:[UInt64] = [0xc,0x5,0x6,0xb,0x9,0x0,0xa,0xd,0x3,0xe,0xf,0x8,0x4,0x7,0x1,0x2]
let Sbox_inv:[UInt64] = [5, 14, 15, 8, 12, 1, 2, 13, 11, 4, 6, 3, 0, 7, 9, 10]
let PBox:[UInt64] = [0,16,32,48,1,17,33,49,2,18,34,50,3,19,35,51,
                    4,20,36,52,5,21,37,53,6,22,38,54,7,23,39,55,
                    8,24,40,56,9,25,41,57,10,26,42,58,11,27,43,59,
                    12,28,44,60,13,29,45,61,14,30,46,62,15,31,47,63]
let PBox_inv:[UInt64] = [0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 1, 5, 9, 13, 17, 21, 25, 29, 33, 37, 41, 45, 49, 53, 57, 61, 2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58, 62, 3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63]

enum IntBigKeySize {
    case s80bit, s128bit;
}

struct IntBig {
    var strKey : String
    let strType: IntBigKeySize
    init(str:String) {
        self.strKey = str
        if strKey.characters.count == 10 {
            self.strType = IntBigKeySize.s80bit
            strKey = str.utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 2).pad(with: "0", toLength: 8) }
        } else if strKey.characters.count == 16 {
            self.strType = IntBigKeySize.s128bit
            strKey = str.utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 2).pad(with: "0", toLength: 8) }
        } else {
            self.strType = IntBigKeySize.s80bit
            strKey = ""
        }
        
    }

    func extract64BitKey() -> UInt64 {
        let index = self.strKey.index(self.strKey.startIndex, offsetBy: 64)
        let str = self.strKey.substring(to: index)
        
        let i = strtoull(str, nil, 2)
        return i
    }
    
    mutating func getNextKeyAtRound(index: Int) {
        self.strKey = (self.strType == .s80bit) ? self.newKey80Bit(index: index) : self.newKey128Bit(index: index)
    }
    
    private func newKey80Bit(index: Int) -> String {
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
        return newkey
    }
    
    private func newKey128Bit(index: Int) -> String {
        var newkey = ""
        
        //Shift key
        var startIndex = self.strKey.index(self.strKey.startIndex, offsetBy: 61)
        newkey.append(self.strKey.substring(from: startIndex))
        newkey.append(self.strKey.substring(to: startIndex))
        
        // SBox
        let inSBoxStr1 = newkey.substring(start: 0, end: 4)
        let x1 = Int(strtoll(inSBoxStr1, nil, 2))
        let intOutSBox1 = Sbox[x1]
        let outSBoxStr1 = String(intOutSBox1, radix: 2).pad(with: "0", toLength: 4)
        startIndex = newkey.index(newkey.startIndex, offsetBy: 0)
        var toIndex = newkey.index(newkey.startIndex, offsetBy: 4)
        newkey = newkey.replacingCharacters(in: Range<String.Index>(uncheckedBounds: (lower: startIndex, upper: toIndex)), with: outSBoxStr1)
        
        let inSBoxStr2 = newkey.substring(start: 4, end: 8)
        let x2 = Int(strtoll(inSBoxStr2, nil, 2))
        let intOutSBox2 = Sbox[x2]
        let outSBoxStr2 = String(intOutSBox2, radix: 2).pad(with: "0", toLength: 4)
        startIndex = newkey.index(newkey.startIndex, offsetBy: 4)
        toIndex = newkey.index(newkey.startIndex, offsetBy: 8)
        newkey = newkey.replacingCharacters(in: Range<String.Index>(uncheckedBounds: (lower: startIndex, upper: toIndex)), with: outSBoxStr2)
        
        
        //XOR round counter
        let inXorStr = newkey.substring(start: 61, end: 66)
        let x = Int(strtoll(inXorStr, nil, 2))
        let intOutXor = x ^ index
        let outXorStr = String(intOutXor, radix: 2).pad(with: "0", toLength: 5)
        startIndex = newkey.index(newkey.startIndex, offsetBy: 61)
        toIndex = newkey.index(newkey.startIndex, offsetBy: 66)
        newkey = newkey.replacingCharacters(in: Range<String.Index>(uncheckedBounds: (lower: startIndex, upper: toIndex)), with: outXorStr)
        return newkey
    }
    
}

class PRESENTCipher: NSObject {
    
    let rounds:Int = 32
    var roundkeys:[UInt64] = []
    
    init?(key:String?) {
        super.init()
        if let key = key {
            if key.characters.count * 8 == 80 {
                //80 bit
                self.roundkeys = self.generateRoundKey80Bit(key: key)
            } else if key.characters.count * 8 == 128 {
                //128 bit
                self.roundkeys = self.generateRoundKey128Bit(key: key)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func encrypt(block:String) -> String {
        // block is 8byte String ascii (length is 8)
        let hexBlock = self.asciiToHex(str: block)
        var state = self.stringToNumber(str: hexBlock)
        for i in 0...self.rounds - 2 {
            state = self.addRoundKey(state: state, key: self.roundkeys[i])
            state = self.sBoxLayer(state: state)
            state = self.pPlayer(state: state)
            print("")
        }
        let cipher = self.addRoundKey(state: state, key: self.roundkeys[self.rounds - 1])
        return self.numberToString(num: cipher)
    }
    
    func decrypt(block:String) -> String {
//        Decrypt 1 block (8 bytes)
//        
//        Input:  ciphertext block as hex string
//        Output: plaintext block as raw string
        var state = self.stringToNumber(str: block)
        let maxIdx = self.rounds - 1
        for i in 0...maxIdx-1 {
            state = self.addRoundKey(state: state, key: self.roundkeys[maxIdx - i])
            state = self.pPlayerInv(state: state)
            state = self.sBoxLayerInv(state: state)
            print("")
        }
        let decipher = self.addRoundKey(state: state, key: self.roundkeys[0])
        let hex = self.numberToString(num: decipher)
        
        return Util.hexStringtoAscii(hex)
    }
    
    func addRoundKey(state:UInt64, key:UInt64) -> UInt64 {
        return state ^ key
    }
    
    func sBoxLayer(state:UInt64) -> UInt64 {
        var output:UInt64 = 0
        for i in 0...15 {
            let idx = (state >> UInt64(i*4)) & 0xF
            output += Sbox[Int(idx)] << UInt64(i*4)
        }
        return output
    }
    
    func pPlayer(state:UInt64) -> UInt64 {
        var output:UInt64 = 0
        for i in 0...63 {
            output += ((state >> UInt64(i)) & 0x01) << PBox[i]
        }
        return output
    }
    
    func sBoxLayerInv(state:UInt64) -> UInt64 {
        //        SBox function for encryption
        //
        //        Input:  64-bit integer
        //        Output: 64-bit integer
        
        var output:UInt64 = 0
        for i in 0...15 {
            let idx = (state >> UInt64(i*4)) & 0xF
            output += Sbox_inv[Int(idx)] << UInt64(i*4)
        }
        return output
    }
    
    func pPlayerInv(state:UInt64) -> UInt64 {
        var output:UInt64 = 0
        for i in 0...63 {
            output += ((state >> UInt64(i)) & 0x01) << PBox_inv[i]
        }
        return output
    }
    
    func generateRoundKey80Bit(key:String) -> [UInt64] {
//        Generate the roundkeys for a 80-bit key
//        
//        Input:
//        key:    the key as a 80-bit integer
//        rounds: the number of rounds as an integer
//        Output: list of 64-bit roundkeys as integers
        
        var subKeys:[UInt64] = []
        var keyIntBig = IntBig.init(str: key)
        
        for i in 1...self.rounds {
            subKeys.append((keyIntBig.extract64BitKey()))
            keyIntBig.getNextKeyAtRound(index: i)
        }
        return subKeys
    }
    
    func generateRoundKey128Bit(key:String) -> [UInt64] {
        //        Generate the roundkeys for a 128-bit key
        //
        //        Input:
        //        key:    the key as a 80-bit integer
        //        rounds: the number of rounds as an integer
        //        Output: list of 64-bit roundkeys as integers
        
        var subKeys:[UInt64] = []
        var keyIntBig = IntBig.init(str: key)
        
        for i in 1...self.rounds {
            subKeys.append((keyIntBig.extract64BitKey()))
            keyIntBig.getNextKeyAtRound(index: i)
        }
        return subKeys
    }
    
    func stringToNumber(str:String) -> UInt64 {
        //str : 16 length hex string
        //endcode to hex "xxyyzz..."
//        let encode = str.utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 16, uppercase: true) }
        // integer from hex string
        let intValue = strtoull(str, nil, 16)
//        let intValue = strtoll(str, nil, 16)
        return UInt64(intValue)
    }
    
    func numberToString(num:UInt64) -> String {
        //num to hex string and to normal string
        let hex = String(num, radix: 16)

        return hex
    }
    
    func asciiToHex(str:String) -> String {
        return str.utf8.map{ $0 }.reduce("") { $0 + String($1, radix: 16, uppercase: true) }
    }

}

extension String {
    func pad(with character: String, toLength length: Int) -> String {
        let padCount = length - self.characters.count
        guard padCount > 0 else { return self }
        
        return String(repeating: character, count: padCount) + self
    }
    func substring(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.characters.index(self.startIndex, offsetBy: end)
        let range = startIndex..<endIndex
        
        return self.substring(with: range)
    }
    
    func substring(start: Int, location: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if location < 0 || start + location > self.characters.count
        {
            print("end index \(start + location) out of bounds")
            return ""
        }
        let startIndex = self.characters.index(self.startIndex, offsetBy: start)
        let endIndex = self.characters.index(self.startIndex, offsetBy: start + location)
        let range = startIndex..<endIndex
        
        return self.substring(with: range)
    }
    
    static func hexStringtoAscii(_ hexString : String) -> String {
        
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


