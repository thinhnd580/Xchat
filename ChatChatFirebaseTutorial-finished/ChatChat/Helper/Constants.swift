//
//  Constants.swift
//  XLProjectName
//
//  Created by XLAuthorName ( XLAuthorWebsite )
//  Copyright (c) 2016 XLOrganizationName. All rights reserved.
//

import Foundation

struct Constants {

    static let selectedColor: UIColor = UIColor(red: 36 / 255.0, green: 167 / 255.0, blue: 10 / 255.0, alpha: 1)
    static let deselectedColor: UIColor = UIColor(red: 197 / 255.0, green: 197 / 255.0, blue: 197 / 255.0, alpha: 1)
    static let deselectedBrightColor: UIColor = UIColor(red: 235 / 255.0, green: 235 / 255.0, blue: 235 / 255.0, alpha: 1)
    
	struct Network {
        static let baseUrl = NSURL(string: "https://api.github.com")!
        static let AuthTokenName = "Authorization"
        static let SuccessCode = 200
        static let successRange = 200..<300
        static let Unauthorized = 401
        static let NotFoundCode = 404
        static let ServerError = 500
    }
    
    struct Debug {
        static let crashlytics = false
        static let jsonResponse = false
    }
    
    struct StoryBoardID {
        static let MainViewControllerID = "MainViewController"
        static let LoginViewControllerID = "LoginViewController"
        static let ListFieldViewControllerID = "ListFieldViewController"
        static let FieldCellID = "FieldCell"
        static let TimeCellID = "TimeCell"
        static let StadiumViewCellID = "StadiumViewCell"
    }
    
    struct ConstantsString {
        static let GoogleMapAPIKey = "AIzaSyCDsnW_PJz4w72JSNMAwZU-ShGv19BFxQ0"
        static let bundleID = "com.thjnh195.xchat"
        static let rsaPKey = "RSAPKEY"
        static let rsaSKey = "RSASKEY"
    }
    
    struct FBDatabase {
        static let User = "User"
        static let Channel = "Channel"
    }
}
