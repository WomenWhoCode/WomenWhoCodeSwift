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
    
    var sectionTitles: [String] = ["Select Feature","Select Chapter"]
    
    var features: [Feature]?
    var isSelected: [Bool] = [] //to check if the features is selected
    var featuresOnDisplay: [String] = []
    var displayAllFeatures: Bool = false
    
    
    var delegate: EventsFilterViewControllerDelegate?
    var filters: EventFilters?
    
    
    var networks: [Network] = []
    var chapters: [String] = []
    var isChapterSelected: [Bool] = []
    var chaptersOnDisplay: [String] = []
    var displayAllChapters: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        filters = EventFilters()
        
        getFeatures()
        getChapters()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getChapters() {
        //FIXME: Do a network call to get all the chapters
        ParseAPI.sharedInstance.getNetworks() {(networks,error)-> () in
            self.networks = networks!
            
            for network in self.networks {
                print("Network title: \(network.title)")
                self.chapters.append((network.title)!)
            }
            
            var cnt = 0
            for _ in self.chapters {
                
                if(cnt<3) {
                    self.chaptersOnDisplay.append(self.chapters[cnt])
                }
                if(cnt == 3) {
                    self.chaptersOnDisplay.append("See All")
                }
                
                self.isChapterSelected.append(false)
                cnt += 1
            }
            
            self.tableView.reloadData()
        }

        
    }
    
    
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
                cnt += 1
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
        let numChaptersSelected = filters?.networks?.count
        
        //Add all chapters if none of the chapters are selected
        if numChaptersSelected == 0 {
            for network in networks {
                filters?.networks?.append(network)
            }
            
        }
        
        //Add all features in none of the features are selected
        if numFeaturesSelected == 0 {
            for feature in features! {
                filters?.features?.append(feature)
            }
        }
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! EventCell2
        let section = indexPath.section
        let row = indexPath.row
        
        print("Getting cell for row: \(row) section: \(section) displayAllF: \(displayAllFeatures) displayAllC: \(displayAllChapters)")
        switch section {
        case 0:
            if displayAllFeatures == true {
                cell.textLabel!.text = features![indexPath.row].title
                cell.textLabel?.textAlignment = .Left
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
            
        case 1: //Chapters
            cell.textLabel!.text = chapters[indexPath.row] //features![indexPath.row].title
            if displayAllChapters == true {
                cell.textLabel!.text = chapters[indexPath.row]
                cell.textLabel?.textAlignment = .Left
            }
            else { //See All is being displayed
                cell.textLabel!.text = chaptersOnDisplay[indexPath.row]
                if isSeeAllChapterCell(indexPath) == true {
                    cell.textLabel?.textAlignment = .Center
                }
                
            }
            
            setBorder(cell)
            if isChapterSelected[indexPath.row] == true {
                cell.accessoryType = .Checkmark
            }
            else {
                cell.accessoryType = .None
            }
            //cell.textLabel?.textAlignment = .Left
            cell.textLabel!.font = UIFont.boldSystemFontOfSize(16.0)
            
        default: print("Trying to display cell for invalid section")
        }
        
        
        return cell
    }
    
    
    func isSeeAllChapterCell(indexPath: NSIndexPath) -> Bool {
        
        if indexPath.section == 1 && indexPath.row == 3 {
            return true
        }
        else {
            return false
        }
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
            if displayAllChapters == true {
                return chapters.count
            }
            else {
                return chaptersOnDisplay.count
            }
            
        default: print("Trying to display invalid section items")
        return 0
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        switch section {
        case 0:
            if displayAllFeatures == false {
                if isSeeAllCell(indexPath) == true {
                    print("Selected SeeAll cell in Features section")
                    displayAllFeatures = true
                    tableView.reloadData()
                }
                else {
                    isSelected[indexPath.row] = !isSelected[indexPath.row]
                    
                    if isSelected[indexPath.row] == true {
                        print("Adding feature \(features![indexPath.row].title!) to filters feature list")
                        filters?.features?.append(features![indexPath.row])
                    }
                    
                    tableView.reloadData()
                    
                }
            }
            else {
                isSelected[indexPath.row] = !isSelected[indexPath.row]
                filters?.features?.append(features![indexPath.row])
                tableView.reloadData()
            }
        case 1:
            print("Selected chapters")
            if displayAllChapters == false {
                if isSeeAllChapterCell(indexPath) == true {
                    displayAllChapters = true
                    tableView.reloadData()
                }
                else {
                    isChapterSelected[indexPath.row] = !isChapterSelected[indexPath.row]
                    
                    if isChapterSelected[indexPath.row] == true {
                        print("Adding chapter \(chapters[indexPath.row]) to selected chapters list")
                        filters?.networks?.append(networks[indexPath.row])
                    }
                    
                    tableView.reloadData()
                }
                
            }
            else {
                isChapterSelected[indexPath.row] = !isChapterSelected[indexPath.row]
                if isChapterSelected[indexPath.row] == true {
                    print("Adding chapter \(chapters[indexPath.row]) to selected chapters list")
                    filters?.networks?.append(networks[indexPath.row])
                }
                tableView.reloadData()
            }
            
            tableView.reloadData()
            
        default: print("Wrong selection")
        }
        
    }
    
    func tableView(tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}


