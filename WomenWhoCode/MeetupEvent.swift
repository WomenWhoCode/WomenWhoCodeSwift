//
//  MeetupEvent.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//


/*
{
"created": 1457375548000,
"duration": 9000000,
"group": {
"created": 1311875189000,
"name": "Women Who Code SF",
"id": 2252591,
"join_mode": "open",
"lat": 37.790000915527344,
"lon": -122.4000015258789,
"urlname": "Women-Who-Code-SF",
"who": "Coders"
},
"id": "ngchrlyvfbcc",
"link": "http://www.meetup.com/Women-Who-Code-SF/events/229415666/",
"name": "Mobile Development Group: iOS & Android",
"rsvp_limit": 45,
"status": "upcoming",
"time": 1458610200000,
"updated": 1457382059000,
"utc_offset": -25200000,
"yes_rsvp_count": 26,
"waitlist_count": 0,
"description": "<p>Welcome to WWCode SF Mobile! At this week's technical workshop, we will eat, drink, mingle, listen to a lightning talk and then we will code.</p> <p> If you have interest in Mobile development, need help with a current project, or seek a supportive workspace, please attend.</p> <p> Beginners can pair program with other attendees and build an app! Move at your own pace and get your hands dirty working on projects from initial design to full implementation. Mentors will be floating around to answer any and all questions.</p> <p><b>Schedule:</b></p> <p><br/> 6:30 - 7:00 PM - Mingle, Network and Dinner</p> <p> 7:00 - 7:15 PM - Welcome and LIghtning Talk</p> <p> 7:15 - 9:00 PM - Choose Your Coding Adventure</p> <p>


<b><i>IMPORTANT to do before you arrive:</i></b></p> <p><br/><b>For Android:</b></p> <p><br/>Android apps can be developed on Mac or PC. Please <a href="https://eclipse.org/downloads/packages/eclipse-ide-java-developers/lunasr1a">install Eclipse</a> or<a href="http://developer.android.com/sdk/index.html">Android Studio</a> and the Android SDK on your laptop before you arrive.</p> <p><br/>If you do not have the proper equipment, don't worry. We can pair you up with someone who does.</p> <p>See our <a href="https://github.com/WomenWhoCode/MobileStudyGroup/wiki/Android-Resources">Android Resources page</a> for tutorials and additional info.</p> <p><b>For iOS:</b></p> <p><br/>You will need a Mac computer running OSX 10.7 or later, with Xcode 4.5 or later. Please <a href="https://developer.apple.com/xcode/downloads/">install Xcode</a> from the Mac App Store before you arrive.</p> <p>The Swift option for iOS Development:<br/>For Swift, you will need the most recent versions of OSX and Xcode. Please update, if needed, before you arrive.</p> <p>See our <a href="https://github.com/WomenWhoCode/MobileStudyGroup/wiki/iOS-Resources">iOS Resources page</a> for tutorials and additional info.</p> <p>


<b>Additional Notes:</b></p> <p><br/>This event occurs every other Monday.</p> <p>All technical workshops are intended exclusively for people who identify as women. </p> <p><a href="https://github.com/WomenWhoCode/guidelines-resources/blob/master/code_of_conduct.md">Code of Conduct</a></p> ",
"venue": {
"id": 23953174,
"name": "AWS Loft",
"lat": 37.783287048339844,
"lon": -122.4084243774414,
"repinned": false,
"address_1": "925 Market Street",
"city": "San Francisco",
"country": "us",
"localized_country_name": "USA",
"zip": "",
"state": "CA"
},
"visibility": "public"
}
*/

import Foundation

class MeetupEvent: NSObject {
    
    var createdTS: Int?
    var duration: Int?
    //SKipping Group Information for now
    var meetupLink: String?
    var meetupId: String?
    var meetupName: String?
    var rsvpLimit: Int?
    var status: String?
    var epochTime: Int?
    var epochUpdated: Int?
    var utcOffset: Int?
    var yesRsvpCount: Int?
    var waitlistCount: Int?
    var eventDescription: String?
    var eventVisibility: String?
    var venue: MeetupVenue?
    
    init(dict: NSDictionary){
        meetupId = dict["id"] as? String
        createdTS = dict["created"] as? Int
        duration = dict["duration"] as? Int
        meetupLink = dict["link"] as? String
        meetupName = dict["name"] as? String
        rsvpLimit = dict["rsvp_limit"] as? Int
        status = dict["status"] as? String
        epochTime = dict["time"] as? Int
        epochUpdated = dict["updated"] as? Int
        utcOffset = dict["utc_offset"] as? Int
        yesRsvpCount = dict["yes_rsvp_count"] as? Int
        waitlistCount = dict["waitlist_count"] as? Int
        eventDescription = dict["description"] as? String
        eventVisibility = dict["visibility"] as? String
        //Fixme: Add Venue
        //FixMe: Add Group Information
        //FixMe: Add Members/ attendees etc.,
    }
    
    override var description : String {
        return "MeetupEvent: \(self.meetupName) -- \(self.meetupLink)"
    }
    
}
