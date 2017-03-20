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

}
