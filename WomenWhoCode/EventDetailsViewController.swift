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
    
    //EventDescSegue
    let eventDescSegue = "eventDescSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        event.fetchMeetupEvent(setMeetupEvent)
        event.fetchEventRsvps(updateRsvps)
        initEvent()
        let contentWidth = scrollView.bounds.width
        let contentHeight = CGFloat(1000.0)//scrollView.bounds.height * 2
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
        updateScrollheight()
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
    
    func updateScrollheight(){
        let newSynSize  = self.descriptionLabel.sizeThatFits(CGSizeMake(self.descriptionLabel.frame.size.width, CGFloat.max))
        var newSynFrame = self.descriptionLabel.frame
        newSynFrame.size.height = newSynSize.height
        
        
        // adjust the container view inside the scroll view
        let newContainerHeight = max(self.contentView.frame.height, newSynFrame.origin.y + newSynFrame.size.height)
//        self.contentView.frame.size = CGSizeMake(self.contentView.frame.width, newContainerHeight+150)
        self.contentView.frame.size = CGSizeMake(self.contentView.frame.width, newContainerHeight)
        
        var newContainerFrame =  self.contentView.frame
        newContainerFrame.size.height = newContainerHeight
        self.contentView.frame = newContainerFrame
                self.contentView.layoutIfNeeded()
        self.contentView.backgroundColor = Constants.Color.Orange.light
        
        self.scrollView.backgroundColor = Constants.Color.Gray.dark
        
        // adjust the labels
        descriptionLabel.frame = newSynFrame
        
        //FixMe: Also have to update the contentView frame height for this to work properly.
        
        // set the scroll height
        let contentWidth = self.scrollView.bounds.width
        let contentHeight = self.contentView.frame.origin.y + self.contentView.frame.height // some fudge factor
        self.scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        
        self.scrollView.layoutIfNeeded()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func ondescTap(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier(eventDescSegue, sender: sender)
    }
    
    //Segue into Detail View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == eventDescSegue {
            if let destination = segue.destinationViewController as? EventDescriptionController {
                destination.descriptionText = event.meetupEvent?.eventDescription!
                destination.hidesBottomBarWhenPushed = true
            }
        }
    }

    
    
    func showEventDetails(event: Event){
        let eventDetailsStoryboard = UIStoryboard(name: "EventDetails", bundle: nil)
        let destination = eventDetailsStoryboard.instantiateViewControllerWithIdentifier("eventDescriptionController") as! EventDetailsViewController
        destination.event = event
        destination.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(destination, animated: true)
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
