//
//  Message.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

//{"type":"message","user":"U0PBN2ESY","text":":confused:","ts":"1457822964.000005"}
class Message: NSObject {
    
    var type: String?
    var userId: String?
    var text: String?
    var timestamp: String?
    
    init(dict: NSDictionary){
        type = dict["type"] as? String
        userId = dict["user"] as? String
        text = dict["text"] as? String
        timestamp = dict["ts"] as? String
    }

}
