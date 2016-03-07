//
//  HTTPClient.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class ParseHTTPClient{
    
    //API KEYS
    
    var appId = "sW8VXwGAEeq8FYaKMgcbPfliodb8XA7wx0QXLdx9"
    var clientKey = "HTVvl8X9szeaOlXzI8jEUx0MENGlzDTrCIrPCnIy"
    
    init(){
        Parse.setApplicationId(appId, clientKey: clientKey)
    }
    
    func query(className: String) -> PFQuery{
        return PFQuery(className: className)
    }
    
    func create(parseObject: PFObject, callback: PFBooleanResultBlock?){
        parseObject.saveInBackgroundWithBlock(callback)
    }
    
}
