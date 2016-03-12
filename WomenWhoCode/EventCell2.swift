//
//  EventCell2.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class EventCell2: UITableViewCell {

    
    @IBOutlet weak var eventImageView: UIImageView!
    
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventLocation: UILabel!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var eventTag1: UILabel!
    
    @IBOutlet weak var eventTag2: UILabel!
    
    @IBOutlet weak var eventSpots: UILabel!
    
    
    var event: Event! {
        didSet {
            eventTitle.text = event.name
            eventLocation.text = event.location
            eventDate.text = event.eventDateString
            eventDescription.text = event.eventDescription
            eventTag1.text = "iOS" //FIXME: Change it to event tag
            eventTag2.text = "Swift"
            
            //Display waitlist count or openSpots
            if (event.waitlistCount != 0) {
                eventSpots.text = "\(event.waitlistCount!) waitlisted"
            }
            else {
                eventSpots.text = "\(event.openSpotsCount!) spots left"
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
