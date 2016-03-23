//
//  EventsViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse
import EventKit

class EventsViewController: UIViewController,EventsFilterViewControllerDelegate,UIScrollViewDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var events:[Event] = []
    var filtered:[Event] = []
    var filteredByFeature:[Event] = []
    var filteredByFeatureAndEvent:[Event] = []
    //var savedEventId: String = ""
    var savedEventId: [String] = []

    
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
    
    //Support for infinite scrolling
    var isMoreDataLoading = false
    var loadingMoreView:EventsInfiniteScrollActivityView?
    
    
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
        tableView.separatorStyle = .None
        
        //searchBar functions
        searchBar.delegate = self
        retrieveEvents()
        
        setUpInfiniteScrollView()
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func eventsFilterViewController(eventFilters: EventFilters) {
        print("In filters delegate method")
        
        
        ParseAPI.sharedInstance.getEventsByFilter(eventFilters.networks, features: eventFilters.features) { (events, error) -> () in
            
            if error == nil {
                if let events = events {
                    self.events = events
                    print("Finished retrieving events(cnt = \(events.count)")
                    let features = eventFilters.features
                    let networks = eventFilters.networks
                    
                    //Filter by features
                    for event in events {
                        for feature in features! {
                            if event.eventFeature == feature.title! {
                                print("Adding event with title: \(event.name) and network: \(event.network!.title!)")
                                self.filteredByFeature.append(event)
                            }
                        }
                    }
                    print("filteredByFeature count : \(self.filteredByFeature.count)")
                    
                    if self.filteredByFeature.count > 0 {
                        for event in self.filteredByFeature {
                            for network in networks! {
                                if event.chapter == network.title {
                                    
                                    self.filteredByFeatureAndEvent.append(event)
                                }
                            }
                        }
                    }
                    print("filteredByFeatureAndEvent count : \(self.filteredByFeatureAndEvent.count)")
                    self.events = self.filteredByFeatureAndEvent
                    self.filteredByFeature = []
                    self.filteredByFeatureAndEvent = []
                    self.tableView.reloadData()
                    
                }
            }
            else {
                print("Error retrieving events with the current filters")
            }
        }
        
    }
    
    
    @IBAction func onFilter(sender: AnyObject) {
        //let filtersVC =
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let navigationController = segue.destinationViewController as! UINavigationController
        let filters = navigationController.topViewController as! EventsFilterViewController
        
        filters.delegate = self
        
    }
    
    
    //Retrieve Events from Parse DB
    func retrieveEvents() {
        print("In retrieve Events")
        ParseAPI.sharedInstance.getEvents() {(events,error)-> () in
            if error == nil {
                if let events = events {
                    
                    if self.isMoreDataLoading == true {
                        self.events = Event.mergeEvents(self.events, additionalEvents: events)
                        self.isMoreDataLoading = false
                    }
                    else {
                        self.events = events
                    }
                    
                    var cnt = 0
                    
                    for event in self.events {
                        self.savedEventId.append("")
                        
                    }
                    self.refreshControl.endRefreshing()
                    self.loadingMoreView!.stopAnimating()
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
        
        for i in 0 ..< customView.subviews.count {
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
//                            for var i=0; i<self.labelsArray.count; ++i {
                            for i in 0..<self.labelsArray.count {
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
        currentColorIndex += 1
        
        return returnColor
    }
    
    //EKEvent related code
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate)->String {
        
        let event = EKEvent(eventStore: eventStore)
        var success = false
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.saveEvent(event, span: .ThisEvent, commit: true)
            success = true
            return event.eventIdentifier
            
        } catch {
            print("Could not save Event")
            
        }
        
        return ""
        
    }
    
    func deleteEvent(eventStore: EKEventStore, eventId: String) {
        
        let eventToRemove = eventStore.eventWithIdentifier(eventId)
        if eventToRemove != nil {
            do {
                try eventStore.removeEvent(eventToRemove!, span: .ThisEvent)
            } catch {
                print("Could not delete Event")
            }
        }
    }
    
    func addEventToCalendar(eventDate: String, eventTitle: String)-> String {
        
        let eventStore = EKEventStore()
        let dateFormatter = NSDateFormatter()
        
        let eventDateTZ = "\(eventDate)"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        
        let startDate = dateFormatter.dateFromString(eventDateTZ)
        let startDateUTC = startDate!.dateByAddingTimeInterval(0)
        let endDate = startDate!.dateByAddingTimeInterval(60*60)
        
        if(EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
            eventStore.requestAccessToEntityType(.Event, completion: {
                (granted:Bool, error: NSError?) -> Void in
                return self.createEvent(eventStore, title: eventTitle, startDate: startDateUTC, endDate: endDate)
                
            })
        }
        else {
            return createEvent(eventStore,title: eventTitle, startDate: startDateUTC, endDate: endDate)
        }
        
        return ""
        
    }
    
    func deleteEventFromCalendar(eventId: String) {
        
        let eventStore = EKEventStore()
        if(EKEventStore.authorizationStatusForEntityType(.Event) == EKAuthorizationStatus.Authorized) {
            deleteEvent(eventStore, eventId: eventId)
            
        }
    }
    
    //*** Infinite Scrolling related code **********
    func setUpInfiniteScrollView() {
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, EventsInfiniteScrollActivityView.defaultHeight)
        loadingMoreView = EventsInfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += EventsInfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, EventsInfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                retrieveEvents()
            }
        }
    }
    


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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
        let addAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Add to\nCalendar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let addMenu = UIAlertController(title: nil, message: "Adding to Calendar", preferredStyle: .ActionSheet)
            //let addAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: nil)
            let addAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                print("event title: \(self.events[indexPath.row].name!) date: \(self.events[indexPath.row].eventDateString!)")
                let eventDate = "\(self.events[indexPath.row].eventDateForEvent!)"
                let eventTitle = "\(self.events[indexPath.row].name!)"
                let eventId = self.addEventToCalendar(eventDate, eventTitle: eventTitle)
                let row = indexPath.row
                if eventId != "" {
                    self.savedEventId[row] = eventId
                    let alertView = UIAlertView(title: eventTitle, message: "Event added to Calendar", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Dismiss")
                    alertView.show()
                }
                self.tableView.reloadData()
                
            })
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction) -> Void in
                self.onCancel()
            })
            
            addMenu.addAction(addAction)
            addMenu.addAction(cancelAction)
            
            
            self.presentViewController(addMenu, animated: true, completion: nil)
        })
        addAction.backgroundColor = Constants.Color.Green.light
        
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete from\nCalendar" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            let deleteMenu = UIAlertController(title: nil, message: "Deleting from Calendar", preferredStyle: .ActionSheet)
            //let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler:nil)
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
                if self.savedEventId[indexPath.row] != "" {
                    self.deleteEventFromCalendar(self.savedEventId[indexPath.row])
                    let alertView = UIAlertView(title: self.events[indexPath.row].name!, message: "Event removed from Calendar", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Dismiss")
                    alertView.show()
                }
                self.tableView.reloadData()
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:{ (action:UIAlertAction) -> Void in
                self.onCancel()
            })

            deleteMenu.addAction(deleteAction)
            deleteMenu.addAction(cancelAction)
            
            
            self.presentViewController(deleteMenu, animated: true, completion: nil)
        })
        deleteAction.backgroundColor = Constants.Color.Red.light
        
        
        return [deleteAction,addAction]
    }
    
    func onCancel() {
        self.tableView.reloadData()
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
        
        if(filtered.count >= 0) {
            searchActive = true
        }
        
        self.tableView.reloadData()
    }
    
}


