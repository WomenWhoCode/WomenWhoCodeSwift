//
//  EventTableViewCell.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 3/5/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventLocation: UILabel!
    
    @IBOutlet weak var eventMonth: UILabel!
    
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //FIXME: Update this code once we have a Event Model. For now, put placeholder text
        
        eventTitle.text = "Intro to Swift2.0"
        eventLocation.text = "Realm, San Francisco,CA"
        eventMonth.text = "MAR"
        eventDate.text = "2"
        eventDescription.text = "Introduction to Swift2.0, basic data types, functions, closures and otehr interesting topics"
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onRsvp(sender: AnyObject) {
        print("RSVPed for this event!!")
    }
}
