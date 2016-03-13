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
    
    @IBOutlet var name: UILabel!
    @IBOutlet var jobDescription: UILabel!
    @IBOutlet var followingCount: UILabel!
    @IBOutlet var followersCount: UILabel!
    @IBOutlet var badges: UILabel!
    @IBOutlet var awesomeCount: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var networkImage: UIImageView!
    var loggedInUserId = "h0VjEs2aql"
    var profile: Profile!
    var myEvents: [Event] = []
    var eventId: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let eventNib = UINib(nibName: "EventCell2", bundle: nil)
        tableView.registerNib(eventNib, forCellReuseIdentifier: "EventCell2")
        
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.reloadData()
        
        getProfile()
        getMyEvents()
        
        
        
    }
    
    func getMyEvents() {
        //let predicate = NSPredicate(format:"user_id == '\(loggedInUserId)' AND rsvpd == 'true'")
        var predicate = NSPredicate(format:"user_id == '\(loggedInUserId)'")
        var userEventsquery = PFQuery(className: "UserEvents", predicate: predicate)
        
        //FIXME: prelangi : Refactor this code!!
        userEventsquery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) events for this user.")
                if let objects = objects {
                    for object in objects {
                        self.eventId = object["event_id"] as! String
                        print("Event id: \(self.eventId)")
                        
                        ParseAPI.sharedInstance.getEventWithEventId(self.eventId!, completion: { (event, error) -> () in
                            if error == nil {
                                //let event = Event(object: event)
                                if let newEvent = event {
                                    print("Event title: \(newEvent.name!)")
                                    
                                    self.myEvents.append(newEvent)
                                    print("Reloading myEvents page")
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
        jobDescription.text = profile.jobTitle! ?? ""
        followingCount.text = "\(profile.followingCount! ?? 0)"
        followersCount.text = "\(profile.followersCount! ?? 0)"
        badges.text = profile!.badges
        awesomeCount.text = "\(profile.awesomeCount! ?? 0)"
        if(profile.imageUrl != nil) {
            profileImage.setImageWithURL(NSURL(string: profile.imageUrl!)!)
        } else {
            profileImage.image = UIImage(named: "professional")
        }
        if ( profile.network.imageUrl != nil && profile.network.imageUrl != "") {
            networkImage.setImageWithURL(NSURL(string: profile.network.imageUrl!)!)
        } else {
            // Network object is not linked
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
        switch sender.selectedSegmentIndex {
        case 0:
            print("Selected Events page; myEvents cnt = \(myEvents.count)")
            self.tableView.hidden = false
            self.tableView.reloadData()
            
        case 1:
            print("Selected Network page")
            self.tableView.hidden = true
        case 2:
            print("Selected Topics page")
            self.tableView.hidden = true
        default: print("Wrong selection")
        }
        
    }
    
    
    
    
    
    
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("called cellForRowAtIndexPath for row: \(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell2", forIndexPath: indexPath) as! EventCell2
        cell.event = myEvents[indexPath.row]
        
        return cell
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myEvents.count
    }
    
}

