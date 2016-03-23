//
//  EventDetailsViewController.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EventDetailsViewController: UIViewController,CLLocationManagerDelegate, MKMapViewDelegate{
    
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attendeeLabel: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var rsvpView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var event: Event!
    var rsvps:[MeetupMember] = []
    var currentRegion:MKCoordinateRegion!
    var mapManager:CLLocationManager!
    var geocoder: CLGeocoder!
    var eventAddress: String?
    
    //EventDescSegue
    let eventDescSegue = "eventDescSegue"
    let eventDetailsStoryboard = UIStoryboard(name: "EventDetails", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        event.fetchMeetupEvent(setMeetupEvent)
        event.fetchEventRsvps(updateRsvps)
        initEvent()
        setUpMap()
    }
    
    func initEvent(){
        nameLabel.text = event.name
        descriptionLabel.text = event.eventDescription!
        locationLabel.text = event.location!
    }
    
    func setUpMap(){
        geocoder = CLGeocoder()
        
        mapManager = CLLocationManager()
        mapManager.delegate = self
        checkLocationAuthorizationStatus()
        mapManager.desiredAccuracy = kCLLocationAccuracyBest
        mapManager.startUpdatingLocation()
        
        mapView.delegate = self
        
        let regionRadius: CLLocationDistance = 2000
        //FixMe: Coordinate to User location
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    func setMeetupEvent(meetupEvent: MeetupEvent){
        event.meetupEvent = meetupEvent
        nameLabel.text = meetupEvent.meetupName
        locationLabel.text = meetupEvent.venue?.venueName != nil ? meetupEvent.venue?.description : ""
        attendeeLabel.text = "\(meetupEvent.rsvpLimit! - meetupEvent.yesRsvpCount!)/\(meetupEvent.rsvpLimit!)"
        networkLabel.text = meetupEvent.groupName
        eventDate.text = meetupEvent.eventDate
        print(Event.eventFromMeetupEvent(meetupEvent))
        setMeetupDescription()
        showMeetupAddress()
        updateScrollheight()
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            mapManager.requestWhenInUseAuthorization()
        }
    }
    
    func showMeetupAddress(){
        self.eventAddress = (self.event.meetupEvent?.venue?.description)!
        geocoder.geocodeAddressString(eventAddress!,
                                      completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
                                        if let placemarks = placemarks{
                                            self.mapView.addAnnotation(MKPlacemark(placemark: placemarks[0]))
                                            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                                        }
        })
    }
    
    func updateRsvps(members: [MeetupMember]){
        self.rsvps = members
        userCollectionView.reloadData()
    }
    
    func setMeetupDescription(){
        let labelFont = descriptionLabel.font
        do{
            let attrStr = try NSAttributedString(
                data: (event.meetupEvent?.eventDescription!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            descriptionLabel.attributedText = attrStr
            descriptionLabel.font = labelFont
        }catch{
            
        }
    }
    
    func updateScrollheight(){
        let newSynSize  = self.descriptionLabel.sizeThatFits(CGSizeMake(self.descriptionLabel.frame.size.width, CGFloat.max))
        var newSynFrame = self.descriptionLabel.frame
        newSynFrame.size.height = newSynSize.height
        
        
        // adjust the container view inside the scroll view
        let newContainerHeight = max(self.contentView.frame.height, newSynFrame.origin.y + newSynFrame.size.height)
        self.contentView.frame.size = CGSizeMake(self.contentView.frame.width, newContainerHeight)
        
        var newContainerFrame =  self.contentView.frame
        newContainerFrame.size.height = newContainerHeight
        self.contentView.frame = newContainerFrame
        self.contentView.layoutIfNeeded()
        
        // adjust the labels
        descriptionLabel.frame = newSynFrame
        
        self.scrollView.contentSize = self.contentView.frame.size
        self.scrollView.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func ondescTap(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier(eventDescSegue, sender: sender)
    }
    
    
    @IBAction func onMapTap(sender: UITapGestureRecognizer) {
        if let eventAddress = self.eventAddress{
        let encodedAddress = eventAddress.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.symbolCharacterSet())!
        let mapUrl = "http://maps.apple.com/?address=\(encodedAddress)"
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"http://maps.apple.com/")!)) {
            UIApplication.sharedApplication().openURL(NSURL(string: mapUrl)!)
        } else {
            print("Error trying to open http://maps.apple.com/");
        }
        }
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
    
    @IBAction func onRSVPYesTap(sender: UIButton) {
        showMeetupConnect(sender)
    }
    
    @IBAction func onRSVPNoTap(sender: UIButton) {
        showMeetupConnect(sender)
    }
}

extension EventDetailsViewController: UIPopoverPresentationControllerDelegate{
    
    func showMeetupConnect(sender: AnyObject){
        let meetupController = eventDetailsStoryboard.instantiateViewControllerWithIdentifier("MeetupLoginController") as! MeetupLoginViewController
        meetupController.hidesBottomBarWhenPushed = true
        
        meetupController.modalPresentationStyle = .Popover
        meetupController.preferredContentSize = CGSizeMake(210, 100)
        
        let popoverMenuViewController = meetupController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender as? UIView
        popoverMenuViewController?.sourceRect = CGRect(
            x: 0,
            y: 0,
            width: 1,
            height: 1)
        presentViewController(
            meetupController,
            animated: true,
            completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}

extension EventDetailsViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        for i in 0 ..< rsvps.count{
            print(rsvps[i].thumbImage!)
        }
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
