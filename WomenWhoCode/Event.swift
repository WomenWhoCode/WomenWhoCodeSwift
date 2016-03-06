//
//  Event.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 3/5/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    var name: String?
    var location: String?
    var eventDate : NSDate?  //will contain the complete event time details (month,date and time)
    var createdAt: NSDate?
    var eventDescription: String? //description is already present in the super class and gives an error
    var type: String?  //Can be Mobile, Web, Social ; Will be used to load the correct image in the Event listing
    var attendeeLimit: Int?
    var rsvpCount: Int? //number of attendees that are currently attending
    var chapter: String? //FIXME: Do we need this ?
    
    //Derived Objects
    var timeInString: String?
    var eventMonth: String?
    var eventDay: String?
    
    override init() {
        
        //FIXME: Temporary initialization
        name = "Intro to Swift2.0"
        location = "Realm, San Francisco,CA"
        eventDate = NSDate(timeIntervalSinceNow: 20)
        createdAt  = NSDate(timeIntervalSinceNow: 0)
        eventDescription = "Introduction to Swift2.0, basic data types, functions, closures and other interesting topics"
        type = "Mobile"
        attendeeLimit = 50
        rsvpCount = 20
        chapter = "SFO"
        
        //Derived objects temporary initialization
        eventMonth = "MAR"
        eventDay = "2"
        
        
    }
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        location = dictionary["location"] as? String
        eventDate = dictionary["event_date"] as? NSDate
        createdAt  = dictionary["created_at"] as? NSDate
        eventDescription = dictionary["description"] as? String
        type = dictionary["type"] as? String
        attendeeLimit = dictionary["attendee_limit"] as? Int
        rsvpCount = dictionary["rsvp_count"] as? Int
        chapter = dictionary["chapter"] as? String
        
        
    }
    
}
