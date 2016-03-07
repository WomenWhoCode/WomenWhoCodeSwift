//
//  EventDetailsViewController.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attendeeLabel: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initEvent()
    }
    
    func initEvent(){
        nameLabel.text = event.name
        eventDate.text = "\(event.eventMonth!) \(event.eventDay!)"
        descriptionLabel.text = event.eventDescription!
        locationLabel.text = event.location!
        //FixMe: Currently nil values. Handle them later
        
        print(event.attendeeLimit)
        print(event.rsvpCount)

//        attendeeLabel.text = "\(event.attendeeLimit! - event.rsvpCount!)/ \(event.attendeeLimit)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
