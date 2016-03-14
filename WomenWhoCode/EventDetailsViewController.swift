//
//  EventDetailsViewController.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attendeeLabel: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var event: Event!
    var rsvps:[MeetupMember] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        event.fetchMeetupEvent(setMeetupEvent)
        event.fetchEventRsvps(updateRsvps)
        initEvent()
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 2
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
    }
    
    func initEvent(){
        nameLabel.text = event.name
        descriptionLabel.text = event.eventDescription!
        locationLabel.text = event.location!
    }
    
    func setMeetupEvent(meetupEvent: MeetupEvent){
        event.meetupEvent = meetupEvent
        nameLabel.text = meetupEvent.meetupName
        locationLabel.text = meetupEvent.venue?.venueName != nil ? meetupEvent.venue?.description : ""
        attendeeLabel.text = "\(meetupEvent.rsvpLimit! - meetupEvent.yesRsvpCount!)/\(meetupEvent.rsvpLimit!)"
        networkLabel.text = meetupEvent.groupName
        eventDate.text = meetupEvent.eventDate
        setMeetupDescription()
    }
    
    func updateRsvps(members: [MeetupMember]){
        self.rsvps = members
        userCollectionView.reloadData()
    }
    
    func setMeetupDescription(){
        do{
            let attrStr = try NSAttributedString(
                data: (event.meetupEvent?.eventDescription!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            descriptionLabel.attributedText = attrStr
        }catch{
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension EventDetailsViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rsvps.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WWC_UserEventCell", forIndexPath: indexPath) as! MeetupRsvp
        let rsvpMember = rsvps[indexPath.row]
        if let thumbImage = rsvpMember.thumbImage{
            cell.userImage.setImageWithURL(NSURL(string: thumbImage)!)
        }
        return cell
    }
    
}
