//
//  EventsViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class EventsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var events:[Event] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        //register tableView cell xib
        let eventNib = UINib(nibName: "EventCell", bundle: nil)
        tableView.registerNib(eventNib, forCellReuseIdentifier: "EventCell")
        
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //tableView.reloadData()
        // Do any additional setup after loading the view.
        //event = Event()
        
        //Do a PFQuery to see if you are getting all the events
        retrieveEvents()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FIXME: This is a temporary function. Needs to be replaced with an API call to retrieve
    // events in a sorted manner
    func retrieveEvents() {
        ParseAPI.sharedInstance.getEvents() {(events,error)-> () in
            self.events = events!
//            print("In VC: Retrieved \(self.events.count) events")
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //FIXME: Change this according to the number of events we have
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        if events.count > 0 {
            cell.event = events[indexPath.row]
//            print("row: \(indexPath.row) name: \(cell.event.name)")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
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
