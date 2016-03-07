//
//  UserSearchViewController.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController {
    
    //Identifiers
    let userSearchCellId = "WWC_UserSearchCell"
    
    var searchBar: UISearchBar!
    
    var profiles:[Profile] = []
    
    @IBOutlet weak var userSearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUserCell()
        initSearchBar()
        retrieveProfiles()
    }
    
    func initSearchBar(){
        searchBar = UISearchBar()
        searchBar?.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
    func initUserCell(){
        let cellNib = UINib(nibName: "UserProfileCell", bundle: NSBundle.mainBundle())
        userSearchTableView.registerNib(cellNib, forCellReuseIdentifier: userSearchCellId)
        userSearchTableView.estimatedRowHeight = 200
        userSearchTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //FIXME: This is a temporary function. Needs to be replaced with an API call to retrieve
    // events in a sorted manner
    func retrieveProfiles() {
        ParseAPI.sharedInstance.getProfiles({ (profiles, error) -> () in
            self.profiles = profiles!
            self.userSearchTableView.reloadData()
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UserSearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(userSearchCellId, forIndexPath: indexPath) as! UserProfileCell
        cell.profile = profiles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
}