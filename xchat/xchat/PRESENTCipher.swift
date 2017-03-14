//
//  PRESENTCipher.swift
//  xchat
//
//  Created by ThinhND on 3/14/17.
//  Copyright © 2017 thjnh195. All rights reserved.
//

import UIKit

class PRESENTCipher: NSObject {
    
    //      0   1   2   3   4   5   6   7   8   9   a   b   c   d   e   f
    let Sbox:[Int64] = [0xc,0x5,0x6,0xb,0x9,0x0,0xa,0xd,0x3,0xe,0xf,0x8,0x4,0x7,0x1,0x2]
    let Sbox_inv:[Int64] = [Sbox.index(x) for x in xrange(16)]
    let PBox:[Int64] = [0,16,32,48,1,17,33,49,2,18,34,50,3,19,35,51,
    4,20,36,52,5,21,37,53,6,22,38,54,7,23,39,55,
    8,24,40,56,9,25,41,57,10,26,42,58,11,27,43,59,
    12,28,44,60,13,29,45,61,14,30,46,62,15,31,47,63]
    let PBox_inv:[Int64] = [PBox.index(x) for x in xrange(64)]
    
    override init() {
        
    }

}
