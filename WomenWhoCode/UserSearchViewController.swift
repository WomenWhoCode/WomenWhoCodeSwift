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
    
    @IBOutlet weak var userSearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUserCell()
        initSearchBar()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UserSearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(userSearchCellId, forIndexPath: indexPath) as! UserProfileCell
//        cell.profile = Profile()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}