//
//  Feature.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class Feature: NSObject {
    
    var objectId: String?
    var auto_subscribe: Bool? //FIXME: Do we need this ? 
    var title: String?
    var subscribe_count: Int? //FIXME: Do we need this ? May be for topics
    
    override init() {
        super.init()
        
        objectId        = ""
        auto_subscribe  = false
        title           = "Swift"
        subscribe_count = 0
        

    }
    
    init(dictionary: NSDictionary) {
        super.init()
        auto_subscribe  = dictionary["auto_subscribe"] as? Bool
        title           = dictionary["title"] as? String
        subscribe_count = dictionary["subscribe_count"] as? Int
        
        
    }
    
    init(object: PFObject) {
        super.init()
        objectId        = object.objectId
        auto_subscribe  = object["auto_subscribe"] as? Bool
        title           = object["title"] as? String
        subscribe_count = object["subscribe_count"] as? Int

        
    }
    
    
}
