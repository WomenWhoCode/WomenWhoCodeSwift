//
//  MeetupMember.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import Foundation

/*
"member": {
"id": 12040761,
"name": "Kasie",
"photo": {
"id": 254726189,
"highres_link": "http://photos2.meetupstatic.com/photos/member/6/6/4/d/highres_254726189.jpeg",
"photo_link": "http://photos4.meetupstatic.com/photos/member/6/6/4/d/member_254726189.jpeg",
"thumb_link": "http://photos2.meetupstatic.com/photos/member/6/6/4/d/thumb_254726189.jpeg"
},
"event_context": {
"host": false
}

*/
class MeetupMember: NSObject {
    var memberId: String?
    var memberName: String?
    var photoId: String?
    var highResImage: String?
    var photoImage: String?
    var thumbImage: String?
    
    init(dict: NSDictionary){
        memberId = dict["id"] as? String
        memberName = dict["name"] as? String
        if let photo = dict["photo"] as? NSDictionary{
            photoId = photo["id"] as? String
            highResImage = photo["highres_link"] as? String
            photoImage = photo["photo_link"] as? String
            thumbImage = photo["thumb_link"] as? String
        }
    }
    
    init(url: String = "https://pixabay.com/static/uploads/photo/2015/08/27/10/14/icon-909830_960_720.png"){
        thumbImage = url
    }
    
    //Class Functions
    class func initWithArray(array: [NSDictionary]) -> [MeetupMember]{
        var members:[MeetupMember] = []
        for eventRsvp in array{
            members.append(MeetupMember(dict: eventRsvp["member"] as! NSDictionary))
        }
        return members
    }
}
