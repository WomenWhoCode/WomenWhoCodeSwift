//
//  EventCell2.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class EventCell2: UITableViewCell {
    
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventLocation: UILabel!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var eventTag1: UILabel!
    
    @IBOutlet weak var eventTag2: UILabel!
    
    @IBOutlet weak var eventSpots: UILabel!
    var eventObjectId:String?
    var rsvpd: Bool = false
    
    var event: Event! {
        didSet {
            eventTitle.text = event.name
            eventLocation.text = event.location
            eventDate.text = event.eventDateInMMMDD
            eventDescription.text = event.eventDescription
            eventTag1.text = "iOS" //FIXME: Change it to event tag
            eventTag2.text = "Swift"
            eventObjectId = event.objectId
            
            //Display waitlist count or openSpots
            if (event.waitlistCount != 0) {
                eventSpots.text = " \(event.waitlistCount!) waitlisted"
            }
            else {
                eventSpots.text = " \(event.openSpotsCount!) spots left"
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        eventTag1.layer.cornerRadius = 10
        eventTag1.clipsToBounds = true
        
        eventTag2.layer.cornerRadius = 10
        eventTag2.clipsToBounds = true
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onRSVP(sender: AnyObject) {
        
        rsvpd = !rsvpd
        
        let loggedInUser = "h0VjEs2aql" //FIXME: Change this to get the current User
        var userEvent = PFObject(className:"UserEvents")
        
        
        let predicate = NSPredicate(format:"event_id == '\(eventObjectId!)' AND user_id == '\(loggedInUser)'")
        let query = PFQuery(className: "UserEvents", predicate: predicate)
        
        //FIXME: prelangi : Refactor this code!!
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) profiles.")
                
                if objects!.count == 0 {
                    userEvent["user_id"] = loggedInUser
                    // Add a relation between the Post and Comment
                    userEvent["event_id"] = self.eventObjectId
                    userEvent["rsvpd"] = self.rsvpd
                    
                    // This will save both myPost and myComment
                    userEvent.saveInBackground()
                    
                }
                else {
                    if let objects = objects {
                        for object in objects {
                            object["rsvpd"] = self.rsvpd
                            
                            object.saveInBackground()
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
                
                
                
            }
        }
        
        
    }
    
    
}
