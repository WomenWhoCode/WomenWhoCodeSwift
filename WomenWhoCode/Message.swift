//
//  Message.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import SwiftyJSON

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
    
    init(dict: JSON){
        super.init()
        type = dict["type"].string
        userId = dict["user"].string
        text = dict["text"].string
        timestamp = getDate(dict["ts"].string!).formatTo("MMM dd, h:mma")
    }
    
    func getDate(epoch: String)-> NSDate{
        let epochTs = Double(epoch)
        if let epochTs = epochTs{
            return NSDate(timeIntervalSince1970: epochTs)
        }
        return NSDate()
    }
    
    //Class Functions
    class func initWithArray(array: [NSDictionary], maxId: String? = nil) -> [Message]{
        var messages = [Message]()
        for dictionary in array{
            let message = Message(dict: dictionary)
            messages.append(message)
        }
        return messages
    }
    
    //Class Functions
    class func initWithJSONArray(array: [JSON], maxId: String? = nil) -> [Message]{
        var messages = [Message]()
        for json in array{
            let message = Message(dict: json)
            messages.append(message)
        }
        return messages
    }



}
