//
//  SlackChannel.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import SwiftyJSON

/*
{
"id": "C024BE91L",
"name": "fun",
"is_channel": "true",
"created": 1360782804,
"creator": "U024BE7LH",
"is_archived": false,
"is_general": false,

"members": [
"U024BE7LH",
…
],

"topic": {
"value": "Fun times",
"creator": "U024BE7LV",
"last_set": 1369677212
},
"purpose": {
"value": "This channel is for fun",
"creator": "U024BE7LH",
"last_set": 1360782804
}

"is_member": true,

"last_read": "1401383885.000061",
"latest": { … }
"unread_count": 0,
"unread_count_display": 0
}
*/
class SlackChannel: NSObject {
    var channelId: String?
    var name: String?
    var isChannel: String?
    var createdTs: Int?
    var creator: String?
    var isArchived: Bool?
    var isGeneral: Bool?
    var members: [JSON]?
    var topicValue: String?
    var topicCreator: String?
    var topicLastSet: Int?
    var purposeValue: String?
    var purposeCreator: String?
    var purposeLastSet: Int?
    var isMember: Bool?
    var lastReadTs: String?
    var unreadCount: Int?
    var unreadCountDisplay: Int?
    var latest: [Message]?
    
    init(dict: JSON){
        channelId = dict["id"].string
        name = dict["name"].string
        isChannel = dict["is_channel"].string
        createdTs = dict["created"].int
        creator = dict["creator"].string
        isArchived = dict["is_archived"].bool
        isGeneral = dict["is_general"].bool
        members = dict["members"].array
    }
    
    class func arrayToDict(channels: [SlackChannel]) -> Dictionary<String, SlackChannel> {
        var channelsDict = [String:SlackChannel]()
        for channel in channels{
            channelsDict[channel.channelId!] = channel
        }
        return channelsDict
    }
    
    
    //Class Function
    class func initWithJSONArray(array: [JSON], maxId: String? = nil) -> [SlackChannel]{
        var slackChannels = [SlackChannel]()
        for json in array{
            let slackChannel = SlackChannel(dict: json)
            slackChannels.append(slackChannel)
        }
        return slackChannels
    }

    

}
