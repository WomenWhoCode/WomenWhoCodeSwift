//
//  SlackUser.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import SwiftyJSON

//SlackUser
/*
{
"ok": true,
"user": {
"id": "U023BECGF",
"name": "bobby",
"deleted": false,
"color": "9f69e7",
"profile": {
"first_name": "Bobby",
"last_name": "Tables",
"real_name": "Bobby Tables",
"email": "bobby@slack.com",
"skype": "my-skype-name",
"phone": "+1 (123) 456 7890",
"image_24": "https:\/\/...",
"image_32": "https:\/\/...",
"image_48": "https:\/\/...",
"image_72": "https:\/\/...",
"image_192": "https:\/\/..."
},
"is_admin": true,
"is_owner": true,
"has_2fa": true,
"has_files": true
}
}

*/

class SlackUser: NSObject {
    var userId: String?
    var name: String?
    var deleted: Bool?
    var color: String?
    var firstName: String?
    var lastName: String?
    var realName: String?
    var email: String?
    var skype: String?
    var phone: String?
    var image24: String?
    var image32: String?
    var image48: String?
    var image72: String?
    var image192: String?
    var isAdmin: Bool?
    var isOwner: Bool?
    var has2fa: Bool?
    var hasFiles: Bool?
    
    init(dict: JSON){
        userId = dict["id"].string
        name = dict["name"].string
        deleted = dict["deleted"].bool
        color = dict["color"].string
        firstName = dict["profile"]["first_name"].string
        lastName = dict["profile"]["last_name"].string
        realName = dict["profile"]["real_name"].string
        email = dict["profile"]["email"].string
        skype = dict["profile"]["skype"].string
        phone = dict["profile"]["phone"].string
        image24 = dict["profile"]["image_24"].string
        image32 = dict["profile"]["image_32"].string
        image48 = dict["profile"]["image_48"].string
        image72 = dict["profile"]["image_72"].string
        image192 = dict["profile"]["image_192"].string
        isAdmin = dict["is_admin"].bool
        isOwner = dict["is_owner"].bool
        has2fa = dict["has2fa"].bool
        hasFiles = dict["hasFiles"].bool
    }
    
    class func arrayToDict(users: [SlackUser]) -> [String:SlackUser] {
        var usersDict = [String:SlackUser]()
        for user in users{
            usersDict[user.userId!] = user
        }
        return usersDict
    }
    
    
    //Class Function
    class func initWithJSONArray(array: [JSON], maxId: String? = nil) -> [SlackUser]{
        var slackUsers = [SlackUser]()
        for json in array{
            let slackUser = SlackUser(dict: json)
            slackUsers.append(slackUser)
        }
        return slackUsers
    }
    
}
