//
//  Profile.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class Profile: NSObject {
    var objectId : String?
    var fullName: String?
    var imageUrl: String?
    var user : User?
    var networkName : String?
    var themeType : Int?
    var jobTitle : String?
    
    var followingCount :Int?
    var followersCount :Int?
    var badges :String?
    var awesomeCount :Int?
    
    var network : Network {
        didSet {
            networkName = network.title
        }
    }
    
    override init() {
        
        objectId = ""
        fullName = ""
        imageUrl = ""
        user = User()
        networkName  = ""
        themeType = 0
        jobTitle = ""
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
    
    init(object: PFObject) {
        objectId = object.objectId
        fullName = object["full_name"] as? String
        imageUrl = object["image_url"] as? String
        user  = object["user"] as? User
        
        themeType = object["theme_type"] as? Int
        jobTitle = object["job_title"] as? String
        
        //FIXME: We need to have an array of badges
        badges = object["badges"] as? String
        
        
        //FIXME: Should this be a derived object? 
        networkName = object["network"] as? String
        network = Network(name: networkName!)
        
        followingCount = object["following_count"] as? Int
        followersCount = object["followers_count"] as? Int
        awesomeCount = object["awesome_count"] as? Int
        
//        print("fullName: \(fullName)")
//        print("followingCount: \(followingCount)")
//        print("followersCount: \(followersCount)")
//        print("NetworkName   : \(networkName)")
        
    }
    
}