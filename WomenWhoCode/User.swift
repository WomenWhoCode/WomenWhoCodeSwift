//
//  User.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
    
    var objectId: String?
    var profile: Profile?
    var username : String?  //will contain the complete event time details (month,date and time)
    var updatedAt: NSDate?
    var email: String? //description is already present in the super class and gives an error
    
    override init() {
        
        //FIXME: Temporary initialization
        objectId = "e7HoAPrwQk"
        profile = Profile()
        username = "test"
        updatedAt = NSDate(timeIntervalSinceNow: 20)
        email  = "test@test.com"
        
    }
    
    init(dictionary: NSDictionary) {
        objectId = dictionary["objectId"] as? String
        profile = dictionary["profile"] as? Profile
        updatedAt = dictionary["updatedAt"] as? NSDate
        username = dictionary["username"] as? String
        email = dictionary["email"] as? String
    }
    
    init(object: PFObject) {
        objectId = object["objectId"] as? String
        profile = object["profile"] as? Profile
        updatedAt = object["updatedAt"] as? NSDate
        username = object["username"] as? String
        email = object["email"] as? String

    }

}