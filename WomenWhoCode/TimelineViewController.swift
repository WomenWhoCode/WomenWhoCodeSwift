//
//  TimelineViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController, TimelineCellDelegate {
    var loggedInUserId = "h0VjEs2aql"
    var eventId: String?
    var myEvents: [Event] = []
    var topics :[Feature] = []
    var subscribed_topics :[Feature] = []
    var subscription : [Subscribed] = []
    var posts : [Post] = []
    var filtered_posts : [Post] = []
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    // filtered_posts and myEvents need to be added to timeleine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        //Refresh Control
        setUpRefreshControl()
        
        getMyEvents()
        getTopics()
    }
    
    func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        
        let refreshText = "Fetching new feed"
        let attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(15)]
        
        self.refreshControl.attributedTitle = NSAttributedString(string: refreshText, attributes: attrs)
        self.refreshControl!.tintColor = Constants.Color.Teal.light
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //loadCustomRefreshContents()
        
        self.refreshControl.addTarget(self, action: "getTopics", forControlEvents: UIControlEvents.ValueChanged)
        
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
        for i in 0 ..< topics.count{
            if ((topics[i].auto_subscribe != nil && topics[i].auto_subscribe!)) {
                subscribed_topics.append(topics[i])
                continue
            }
            for j in 0 ..< subscription.count{
                if(subscription[j].feature_id == topics[i].objectId && subscription[j].subscribe != nil && subscription[j].subscribe!) {
                    subscribed_topics.append(topics[i])
                }
            }
        }
        getPosts()
    }
    
    
    func getMyEvents() {
        let predicate = NSPredicate(format:"user_id == '\(loggedInUserId)'")
        let userEventsquery = PFQuery(className: "UserEvents", predicate: predicate)
        
        userEventsquery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        self.eventId = object["event_id"] as? String
                        
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
            self.getFilteredPosts()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
        
    }
    
    func getFilteredPosts() {
        for i in 0 ..< posts.count {
            for j in 0 ..< subscribed_topics.count {
                if(posts[i].feature_id == subscribed_topics[j].objectId) {
                    filtered_posts.append(posts[i])
                }
            }
        }
    }
    
    //Called whenever awesome button is pressed
    func timelineCellDelegate(sender: TimelineCell, onApplaud: Bool) {
        let indexPath = tableView.indexPathForCell(sender)!
        var awesomeCount = filtered_posts[indexPath.row].awesome_count!
        let postObjectId = filtered_posts[indexPath.row].objectId
        if (onApplaud) {
            awesomeCount = awesomeCount+1
        } else {
            awesomeCount = awesomeCount-1
        }
        filtered_posts[indexPath.row].awesome_count = awesomeCount
        sender.awesomeCountLabel.text = "AWESOME X \(awesomeCount)"
        
        print("Updating awesome count of post with objectId: \(postObjectId)")
        
        let query = PFQuery(className:"Post")
        query.getObjectInBackgroundWithId(postObjectId!) {
            (post: PFObject?, error: NSError?) -> Void in
            if error == nil && post != nil {
                //let postActual = Post(object: post!)
                //print("Description: \(postActual.desc!)")
                post!["awesome_count"] = awesomeCount
                post?.saveInBackground()
            } else {
                print("Error in saving awesome count: \(error)")
            }
        }
    }
}
extension TimelineViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineCell
        let row = indexPath.row
        let awesomeCount = filtered_posts[row].awesome_count!
        
        cell.postDesc.URLColor = Constants.Color.Teal.dark
        cell.postDesc.hashtagColor = UIColor.blackColor()
        cell.postDesc.mentionColor = UIColor.blackColor()
        
        cell.postDesc.handleURLTap { (url: NSURL) -> () in
            UIApplication.sharedApplication().openURL(url)
        }
        
        cell.postDesc.text = filtered_posts[indexPath.row].desc
        cell.awesomeCountLabel.text = "AWESOME X \(awesomeCount)"
        cell.delegate = self
        
        for i in 0 ..< subscribed_topics.count {
            if( filtered_posts[indexPath.row].feature_id == subscribed_topics[i].objectId) {
                
                let postImageURL = NSURL(string: subscribed_topics[i].image_url!)
                cell.topicImage.setImageWithURL(postImageURL!)
                cell.topicTitle.text = subscribed_topics[i].title
                //cell.awesomeCountLabel.text = subscribed_topics[i].
                cell.topicView.backgroundColor = UIColor(hexString: subscribed_topics[i].hex_color!)
                cell.backgroundColor = UIColor.whiteColor()
                break
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered_posts.count
    }
    
    
}


