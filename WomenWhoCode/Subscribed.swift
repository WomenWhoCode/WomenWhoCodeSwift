//
//  Subscribed.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class Subscribed: NSObject {
    
var objectId: String?
var userId: String?
var feature_id : String?
var subscribe: Bool?

override init() {
    super.init()
    objectId   = ""
    subscribe  = false
    userId = ""
    feature_id = ""
    }

init(dictionary: NSDictionary) {
    super.init()
    objectId  = dictionary["objectId"] as? String
    userId    = dictionary["user_id"] as? String
    subscribe = dictionary["subscribe"] as? Bool
    feature_id = dictionary["feature_id"] as? String
    }

init(object: PFObject) {
    super.init()
    objectId  = object.objectId
    userId    = object["user_id"] as? String
    subscribe = object["subscribed"] as? Bool
    feature_id = object["feature_id"] as? String
}
}
