//
//  EventsViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class EventsViewController: UIViewController{

    //Identifiers
    let eventDetailsSegueId = "WWC_EventDetailsSegue"
    
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
        
        retrieveEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //FIXME: This is a temporary function. Needs to be replaced with an API call to retrieve
    // events in a sorted manner
    func retrieveEvents() {
        ParseAPI.sharedInstance.getEvents() {(events,error)-> () in
            self.events = events!
            self.tableView.reloadData()
        }
    }
    
  
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == eventDetailsSegueId {
            if let destination = segue.destinationViewController as? EventDetailsViewController {
                if let cell = sender as? EventCell{
                    let indexPath = self.tableView!.indexPathForCell(cell)
                    let index = indexPath!.row
                    destination.event = events[index]
                    
                }
                destination.hidesBottomBarWhenPushed = true
            }
        }
    }
}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        if events.count > 0 {
            cell.event = events[indexPath.row]
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! EventCell
        self.performSegueWithIdentifier(eventDetailsSegueId, sender: selectedCell)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
}


