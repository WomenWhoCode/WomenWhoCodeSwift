//
//  Profile.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class Profile: NSObject {
    var objectId : String?
    var fullName: String?
    var image_url: String?
    var user : User?
    var networkName : String?
    var themeType : Int?
    var jobTitle : String?
    var network : Network
    
    override init() {
        
        objectId = "uyR8kDpdN0"
        fullName = "Test User"
        image_url = ""
        user = User()
        networkName  = "Atlanta"
        themeType = 0
        jobTitle = "Software Developer"
        network = Network()
    }
    
    init(dictionary: NSDictionary) {
        objectId = dictionary["objectId"] as? String
        fullName = dictionary["fullName"] as? String
        image_url = dictionary["image_url"] as? String
        user  = dictionary["user"] as? User
        networkName = dictionary["networkName"] as? String
        themeType = dictionary["themeType"] as? Int
        jobTitle = dictionary["jobTitle"] as? String
        network = (dictionary["network"] as? Network)!    
        
    }
    
}