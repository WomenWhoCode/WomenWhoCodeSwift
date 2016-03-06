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
    var imageUrl: String?
    var user : User?
    var networkName : String?
    var themeType : Int?
    var jobTitle : String?
    var network : Network
    var followingCount :Int?
    var followersCount :Int?
    var badges :String?
    var awesomeCount :Int?
    
    override init() {
        
        objectId = "uyR8kDpdN0"
        fullName = "Test User"
        imageUrl = ""
        user = User()
        networkName  = "Atlanta"
        themeType = 0
        jobTitle = "Software Developer"
        network = Network()
        followingCount = 0
        followersCount = 0
        badges = ""
        awesomeCount = 0
    }
    
    init(dictionary: NSDictionary) {
        objectId = dictionary["objectId"] as? String
        fullName = dictionary["fullName"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        user  = dictionary["user"] as? User
        networkName = dictionary["networkName"] as? String
        themeType = dictionary["themeType"] as? Int
        jobTitle = dictionary["jobTitle"] as? String
        badges = dictionary["badges"] as? String
        network = (dictionary["network"] as? Network)!
        followingCount = dictionary["followingCount"] as? Int
        followersCount = dictionary["followersCount"] as? Int
        awesomeCount = dictionary["awesomeCount"] as? Int
        
    }
    
}