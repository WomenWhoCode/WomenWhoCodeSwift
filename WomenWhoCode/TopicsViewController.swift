//
//  TopicsViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class TopicsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var topics :[Feature] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 320
        tableView.rowHeight = UITableViewAutomaticDimension
        getTopics()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTopics()
    {
         ParseAPI.sharedInstance.getFeatures { (feature, error) -> () in
            self.topics = feature!
            self.tableView.reloadData()
        }
    }
}

extension TopicsViewController: UITableViewDataSource, UITableViewDelegate{
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell", forIndexPath: indexPath) as! TopicCell
                    cell.feature = topics[indexPath.row]
            return cell
        }
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 120
        }
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return topics.count
        }
    }
   

