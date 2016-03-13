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
    var auto_subscribe: Bool?
    var title: String?
    var subscribe_count: Int?
    var desc : String?
    var hex_color : String?
    var image_url :String?
    
    override init() {
        super.init()
        
        objectId        = ""
        auto_subscribe  = false
        title           = "Swift"
        subscribe_count = 0
        desc = ""
        hex_color = ""
        image_url = ""
    }
    
    init(dictionary: NSDictionary) {
        super.init()
        auto_subscribe  = dictionary["auto_subscribe"] as? Bool
        title           = dictionary["title"] as? String
        subscribe_count = dictionary["subscribe_count"] as? Int
        desc = dictionary["description"] as? String
        hex_color = dictionary["hex_color"] as? String
        image_url = dictionary["image_url"] as? String
    }
    
    init(object: PFObject) {
        super.init()
        objectId        = object.objectId
        auto_subscribe  = object["auto_subscribe"] as? Bool
        title           = object["title"] as? String
        subscribe_count = object["subscribe_count"] as? Int
        desc = object["description"] as? String
        hex_color = object["hex_color"] as? String
        image_url = object["image_url"] as? String

    }
}
