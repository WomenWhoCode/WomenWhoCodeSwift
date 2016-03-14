//
//  TimelineViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {
    var loggedInUserId = "h0VjEs2aql"
    var eventId: String?
    var myEvents: [Event] = []
    var topics :[Feature] = []
    var subscribed_topics :[Feature] = []
    var subscription : [Subscribed] = []
    var posts : [Post] = []
    var filtered_posts : [Post] = []

    @IBOutlet var tableView: UITableView!
    // filtered_posts and myEvents need to be added to timeleine

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        getMyEvents()
        getTopics()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        print("\(subscribed_topics.count)")
        getPosts()
    }

    
    func getMyEvents() {
        var predicate = NSPredicate(format:"user_id == '\(loggedInUserId)'")
        var userEventsquery = PFQuery(className: "UserEvents", predicate: predicate)
        
        userEventsquery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {

                if let objects = objects {
                    for object in objects {
                        self.eventId = object["event_id"] as! String
                        
                        ParseAPI.sharedInstance.getEventWithEventId(self.eventId!, completion: { (event, error) -> () in
                            if error == nil {
                                if let newEvent = event {
                                    self.myEvents.append(newEvent)
                                    self.tableView.reloadData()
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

    func getPosts() {
         ParseAPI.sharedInstance.getPosts { (posts, error) -> () in
            self.posts = posts!
            print("\(self.posts.count)")
            self.getFilteredPosts()
            self.tableView.reloadData()
        }
        
    }
    
    func getFilteredPosts() {
        for(var i = 0 ; i < posts.count; i++) {
            for (var j = 0 ; j < subscribed_topics.count; j++) {
                if(posts[i].feature_id == subscribed_topics[j].objectId) {
                    filtered_posts.append(posts[i])
                }
            }
        }
        print("\(filtered_posts.count)")
         print("\(myEvents.count)")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TimelineViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineCell
        cell.postDesc.text = filtered_posts[indexPath.row].desc
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered_posts.count
       }
}


