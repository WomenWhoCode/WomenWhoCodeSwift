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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var events:[Event] = []
    var filtered:[Event] = []
    
    //variables for searchBar support
    var searchActive : Bool = false
    
    //Add support for refresh control
    var refreshControl: UIRefreshControl!
    var customView: UIView!
    var labelsArray: Array<UILabel> = []
    var currentColorIndex = 0
    var currentLabelIndex = 0
    var isAnimating = false
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Refresh Control
        setUpRefreshControl()
        
        
        //register tableView cell xib
        let eventNib = UINib(nibName: "EventCell2", bundle: nil)
        tableView.registerNib(eventNib, forCellReuseIdentifier: "EventCell2")
        
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //searchBar functions
        searchBar.delegate = self
        
        retrieveEvents()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //FIXME: This is a temporary function. Needs to be replaced with an API call to retrieve
    // events in a sorted manner
    func retrieveEvents() {
        print("In retrieve Events")
        ParseAPI.sharedInstance.getEvents() {(events,error)-> () in
            if error == nil {
                if let events = events {
                    self.events = events
                    
                    print("Finished retrieving events")
                    
                    
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    
                }
                
            }
            else {
                print("Error retrieving events")
            }
        }
    }
    
    
    func showEventDetails(event: Event){
        let eventDetailsStoryboard = UIStoryboard(name: "EventDetails", bundle: nil)
        let destination = eventDetailsStoryboard.instantiateViewControllerWithIdentifier("eventDetailsController") as! EventDetailsViewController
        destination.event = event
        destination.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    
    func get_events_count()-> Int {
        if searchActive == true {
            return filtered.count
        }
        else {
            return events.count
        }
    }
    
    func setUpRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.clearColor()
        
        var refreshText = "Fetching new Events"
        var attrs = [NSFontAttributeName : UIFont.boldSystemFontOfSize(15)]
        
        self.refreshControl.attributedTitle = NSAttributedString(string: refreshText, attributes: attrs)
        self.refreshControl!.tintColor = Constants.Color.Teal.light
        
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        //loadCustomRefreshContents()
        
        self.refreshControl.addTarget(self, action: "retrieveEvents", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func loadCustomRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("EventRefreshControl", owner: self, options: nil)
        
        customView = refreshContents[0] as! UIView
        customView.frame = refreshControl.bounds
        
        for var i=0; i<customView.subviews.count; ++i {
            labelsArray.append(customView.viewWithTag(i + 1) as! UILabel)
        }
        
        refreshControl.addSubview(customView)
    }
    
    func animateRefreshStep1() {
        isAnimating = true
        
        UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
            
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformIdentity
                    self.labelsArray[self.currentLabelIndex].textColor = UIColor.blackColor()
                    
                    }, completion: { (finished) -> Void in
                        ++self.currentLabelIndex
                        
                        if self.currentLabelIndex < self.labelsArray.count {
                            self.animateRefreshStep1()
                        }
                        else {
                            self.animateRefreshStep2()
                        }
                })
        })
        
        print("Done with Animation1")
    }
    
    
    func animateRefreshStep2() {
        UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.labelsArray[0].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[1].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[2].transform = CGAffineTransformMakeScale(1.5, 1.5)
            
            
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.labelsArray[0].transform = CGAffineTransformIdentity
                    self.labelsArray[1].transform = CGAffineTransformIdentity
                    self.labelsArray[2].transform = CGAffineTransformIdentity
                    
                    
                    }, completion: { (finished) -> Void in
                        if self.refreshControl.refreshing {
                            self.currentLabelIndex = 0
                            self.animateRefreshStep1()
                        }
                        else {
                            self.isAnimating = false
                            self.currentLabelIndex = 0
                            for var i=0; i<self.labelsArray.count; ++i {
                                self.labelsArray[i].textColor = UIColor.blackColor()
                                self.labelsArray[i].transform = CGAffineTransformIdentity
                            }
                        }
                })
        })
        print("Done with Animation2")
    }
    
    
    func getNextColor() -> UIColor {
        var colorsArray: Array<UIColor> = [UIColor.magentaColor(), UIColor.brownColor(), UIColor.yellowColor(), UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.orangeColor()]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        ++currentColorIndex
        
        return returnColor
    }
    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        print("isAnimating: \(isAnimating)")
//        if refreshControl.refreshing {
//            if !isAnimating {
//                self.animateRefreshStep1()
//                retrieveEvents()
//                
//            }
//        }
//    }

}

extension EventsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell2", forIndexPath: indexPath) as! EventCell2
        if searchActive {
            if filtered.count > 0 {
                cell.event = filtered[indexPath.row]
            }
        }
        else {
            if events.count > 0 {
                cell.event = events[indexPath.row]
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showEventDetails(events[indexPath.row])
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return get_events_count()
    }
}

extension EventsViewController: UISearchBarDelegate {
    
    //******  Search Bar functions
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchActive = true;
        self.searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.view.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar,  textDidChange searchText: String) {
        
        if(searchText=="") {
            filtered = events
        }
        else {
            filtered = events.filter({ (text) -> Bool in
                let tmp: NSString = text.name as String!
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        }
        
        print("Filtered count \(filtered.count) searchText = \(searchText)")
        //        if(filtered.count == 0){
        //            searchActive = false;
        //        } else {
        //            searchActive = true;
        //        }
        
        if(filtered.count >= 0) {
            searchActive = true
        }
        
        self.tableView.reloadData()
    }
    
}


