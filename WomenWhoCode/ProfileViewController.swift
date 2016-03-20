//
//  ProfileViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import AFNetworking
import Parse

class ProfileViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var name: UILabel!
    @IBOutlet var jobDescription: UILabel!
    @IBOutlet var followingCount: UILabel!
    @IBOutlet var followersCount: UILabel!
    @IBOutlet var badges: UILabel!
    @IBOutlet var awesomeCount: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var networkImage: UIImageView!
    var subscribed_topics :[Feature] = []
    var topics :[Feature] = []
    var loggedInUserId = "h0VjEs2aql"
    var profile: Profile!
    var myEvents: [Event] = []
    var eventId: String?
    var subscription : [Subscribed] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex == 0
        tableView.delegate = self
        tableView.dataSource = self
        
        let eventNib = UINib(nibName: "EventCell2", bundle: nil)
        tableView.registerNib(eventNib, forCellReuseIdentifier: "EventCell2")
        
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
        
        getProfile()
        getMyEvents()
        getTopics()
    }
    
    func getMyEvents() {
        //let predicate = NSPredicate(format:"user_id == '\(loggedInUserId)' AND rsvpd == 'true'")
        let predicate = NSPredicate(format:"user_id == '\(loggedInUserId)'")
        let userEventsquery = PFQuery(className: "UserEvents", predicate: predicate)
        
        //FIXME: prelangi : Refactor this code!!
        userEventsquery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                //   print("Successfully retrieved \(objects!.count) events for this user.")
                if let objects = objects {
                    for object in objects {
                        self.eventId = object["event_id"] as! String
                        //    print("Event id: \(self.eventId)")
                        
                        ParseAPI.sharedInstance.getEventWithEventId(self.eventId!, completion: { (event, error) -> () in
                            if error == nil {
                                //let event = Event(object: event)
                                if let newEvent = event {
                                    //    print("Event title: \(newEvent.name!)")
                                    
                                    self.myEvents.append(newEvent)
                                    //    print("Reloading myEvents page")
                                    self.tableView.reloadData()
                                    print("myEvents cnt = \(self.myEvents.count)")
                                }
                                
                            }
                            else {
                                print("Error retrieving events for User with userId: \(self.loggedInUserId)")
                            }
                            
                        })
                        
                    }
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    func getTopics()
    {
        ParseAPI.sharedInstance.getFeatures { (feature, error) -> () in
            self.topics = feature!
            self.getSubscribed()
            self.tableView.reloadData()
        }
    }
    
    func getSubscribed()
    {
        ParseAPI.sharedInstance.getSubscriptions { (subscribed, error) -> () in
            self.subscription = subscribed!
            self.tableView.reloadData()
            self.setSubscribedTopics()
        }
        
    }
    
    func setSubscribedTopics() {
        for(var i = 0 ; i < topics.count; i++) {
            var added = false
            if ((topics[i].auto_subscribe != nil && topics[i].auto_subscribe!)) {
                subscribed_topics.append(topics[i])
                continue
            }
            for (var j = 0 ; j < subscription.count; j++) {
                if(subscription[j].feature_id == topics[i].objectId && subscription[j].subscribe != nil && subscription[j].subscribe!) {
                    subscribed_topics.append(topics[i])
                }
            }
        }
        tableView.reloadData()
    }
    
    
    func getProfile() {
        
        if(profile == nil) {
            ParseAPI.sharedInstance.getProfileWithUserId (loggedInUserId) { (profile, error) -> () in
                if error != nil {
                    print("Error retrieving logged in user from Parse")
                } else {
                    self.profile = profile
                    self.populateFields()
                    
                    
                }
            }
        } else {
            populateFields()
        }
        
    }
    
    func populateFields() {
        
        name.text = profile.fullName! ?? ""
        print("Populated Field for Profile: \(name.text)")
        jobDescription.text = profile.jobTitle! ?? ""
        
        
        if let followingCountActual = profile.followingCount {
            followingCount.text = "\(followingCountActual)"
        }
        else {
            followingCount.text = "0"
        }
        
        if let followersCountActual = profile.followersCount {
            followersCount.text = "\(followersCountActual)"
        }
        else {
            followersCount.text = "0"
        }
        
        
        badges.text = profile!.badges
        
        if let awesomeCountActual = profile.awesomeCount {
            awesomeCount.text = "\(awesomeCountActual)"
        }
        else {
            awesomeCount.text = "0"
        }
        
        if(profile.imageUrl != nil) {
            profileImage.setImageWithURL(NSURL(string: profile.imageUrl!)!)
        } else {
            profileImage.image = UIImage(named: "professional")
        }
        
        print("Network for selected profile: \(profile.networkName), objectId: \(profile.network.objectId)")
        print("Network image_url for selected profile: \(profile.network.imageUrl)")
        
        if ( profile.network.imageUrl != nil && profile.network.imageUrl != "") {
            print("Setting network Image")
            networkImage.setImageWithURL(NSURL(string: profile.network.imageUrl!)!)
        } else {
            // Network object is not linked
            print("2. Network for selected profile: \(profile.networkName)")
            ParseAPI.sharedInstance.getNetworkWithNetworkName(profile.networkName!, completion: { (network, error) -> () in
                if(error != nil ) {
                    print("Error retreiving Network")
                } else {
                    if(network?.imageUrl != nil) {
                        self.networkImage.setImageWithURL(NSURL(string: (network?.imageUrl)!)!)
                    } else {
                        self.networkImage.image = UIImage(named: "gg_bridge3")
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectionChanged(sender: UISegmentedControl) {
        segmentedControl.selectedSegmentIndex = sender.selectedSegmentIndex
        switch sender.selectedSegmentIndex {
        case 0:
            print("Selected Events page; myEvents cnt = \(myEvents.count)")
            self.tableView.hidden = false
            self.tableView.reloadData()
            
        case 1:
            print("Selected Network page \(topics.count)")
            self.tableView.reloadData()
            // self.tableView.hidden = true
        default: print("Wrong selection")
        }
        
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // print("called cellForRowAtIndexPath for row: \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell2", forIndexPath: indexPath) as! EventCell2
        if (segmentedControl.selectedSegmentIndex == 0) {
            cell.event = myEvents[indexPath.row]
            cell.backgroundColor = UIColor.whiteColor()
            cell.eventTitle.textColor = UIColor.darkGrayColor()
            cell.eventImageView.image = UIImage(named: "iOSTeal")
            
        } else {
            cell.eventTitle.text = self.subscribed_topics[indexPath.row].title
            cell.eventTitle.textColor = UIColor.whiteColor()
            cell.eventImageView.image = UIImage(named: "languages")
            if (self.subscribed_topics[indexPath.row].image_url != nil) {
                cell.eventImageView.setImageWithURL(NSURL(string: self.subscribed_topics[indexPath.row].image_url!)!)
            } else {
                cell.eventImageView.image = UIImage(named: "languages")
            }
            cell.eventDate.text = ""
            cell.eventLocation.text = ""
            cell.eventDescription.text = ""
            cell.eventTag1.text = ""
            cell.eventTag2.text = ""
            cell.rsvpLabel.text = ""
            cell.eventLocation.text = ""
            cell.eventSpots.text = ""
            cell.rsvpConfirmedLabel.text = ""
            cell.backgroundColor = UIColor(hexString: topics[indexPath.row].hex_color!)
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentedControl.selectedSegmentIndex == 0) {
            return myEvents.count
        } else {
            return subscribed_topics.count
        }
    }
    
}

