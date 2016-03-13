//
//  EventsFilterViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 3/9/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

protocol EventsFilterViewControllerDelegate {
    func eventsFilterViewController(eventFilters: EventFilters)
}

class EventsFilterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var features: [Feature]?
    var isSelected: [Bool] = [] //to check if the features is selected
    var sectionTitles: [String] = ["Select Feature","Select Chapter"]
    var featuresOnDisplay: [String] = []
    var displayAllFeatures: Bool = false
    var delegate: EventsFilterViewControllerDelegate?
    var filters: EventFilters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        filters = EventFilters()
        
        getFeatures()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FIXME: This is a temporary function. Needs to be replaced with an API call to retrieve
    // events in a sorted manner
    func getFeatures() {
        ParseAPI.sharedInstance.getFeatures() {(features,error)-> () in
            self.features = features!
            
            var cnt = 0
            for feature in features! {
                
                if(cnt<3) {
                    self.featuresOnDisplay.append((feature.title)!)
                }
                if(cnt == 3) {
                    self.featuresOnDisplay.append("See All")
                }
                
                
                self.isSelected.append(false)
                cnt++
            }
            
            print("Set isSelected for \(cnt) features")
            //setFeatureSelection()
            
            self.tableView.reloadData()
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onSearch(sender: AnyObject) {
        let numFeaturesSelected = filters?.features?.count
        print("Selected \(numFeaturesSelected!) features for Event Page")
        delegate?.eventsFilterViewController(filters!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension EventsFilterViewController: UITableViewDataSource, UITableViewDelegate{
    
    func setBorder(view: UIView) {
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UILabel()
        sectionHeader.backgroundColor = Constants.Color.Teal.dark
        sectionHeader.text = sectionTitles[section]
        return sectionHeader
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! UITableViewCell
        let section = indexPath.section
        let row = indexPath.row
        
        print("Getting cell for row: \(row) section: \(section)")
        switch section {
        case 0:
            if displayAllFeatures == true {
                cell.textLabel!.text = features![indexPath.row].title
                //Reset it back to normal
                if isSeeAllCell(indexPath) == true {
                    cell.textLabel?.textAlignment = .Left
                }
            }
            else { //See All is being displayed
                cell.textLabel!.text = featuresOnDisplay[indexPath.row]
                if isSeeAllCell(indexPath) == true {
                    cell.textLabel?.textAlignment = .Center
                }
                
            }
            setBorder(cell)
            cell.textLabel!.font = UIFont.boldSystemFontOfSize(16.0)
        
            
        
            if isSelected[indexPath.row] == true {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
        case 1:
            cell.textLabel!.text = features![indexPath.row].title
            setBorder(cell)
        
            if isSelected[indexPath.row] == true {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
        
        default: print("Trying to display cell for invalid section")
        }
        
        
        return cell
    }
    
    func isSeeAllCell(indexPath: NSIndexPath) -> Bool {
        
        if indexPath.section == 0 && indexPath.row == 3 {
            return true
        }
        else {
            return false
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("Getting numberOfRowsInSection for section: \(section)")
        switch section {
        case 0:
            if displayAllFeatures == true {
                if let features = features {
                    return features.count
                }
                else {
                    return 0
                }
            }
            else {
                print("displayAllFeatures set to 0; So displaying only \(featuresOnDisplay.count) items ")
                return featuresOnDisplay.count
                
            }
        case 1:
            return 2
        default: print("Trying to display invalid section items")
        return 0
        }
        
    }
    
    func tableView(tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
            return sectionTitles[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //sectionTitles.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if displayAllFeatures == false {
            if isSeeAllCell(indexPath) == true {
                print("Selected SeeAll cell in Features section")
                displayAllFeatures = true
                tableView.reloadData()
            }
            else {
                switch indexPath.section {
                case 0:
                    isSelected[indexPath.row] = !isSelected[indexPath.row]
                    print("Adding feature \(features![indexPath.row].title!) to filters feature list")
                    filters?.features?.append(features![indexPath.row].title!)

                    tableView.reloadData()
                default: print("Invalid section")
                
                }
            }
            
        }
        else {
            switch indexPath.section {
            case 0:
                isSelected[indexPath.row] = !isSelected[indexPath.row]
                filters?.features?.append(features![indexPath.row].title!)
                tableView.reloadData()
            default: print("Invalid section")
            }
            
        }
    }
}


