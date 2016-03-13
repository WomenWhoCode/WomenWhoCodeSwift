//
//  Post.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//
import UIKit
import Parse

class Post: NSObject {
    
    var objectId: String?
    var desc: String?
    var feature_id : String?
    var awesome_count: Int?
    
    override init() {
        super.init()
        objectId   = ""
        awesome_count  = 0
        desc = ""
        feature_id = ""
    }
    
    init(dictionary: NSDictionary) {
        super.init()
        objectId  = dictionary["objectId"] as? String
        desc    = dictionary["description"] as? String
        awesome_count = dictionary["awesome_count"] as? Int
        feature_id = dictionary["feature_id"] as? String
    }
    
    init(object: PFObject) {
        super.init()
        objectId  = object.objectId
        desc    = object["description"] as? String
        awesome_count = object["awesome_count"] as? Int
        feature_id = object["feature_id"] as? String    }
}
