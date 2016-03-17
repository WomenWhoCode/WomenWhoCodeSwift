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
    
    //var searchBar: UISearchBar!
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    var profiles:[Profile] = []
    var filtered: [Profile] = []
    
    //variables for searchBar support
    var searchActive : Bool = false
    
    @IBOutlet weak var userSearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar functions
        userSearchBar.delegate = self
        
        userSearchTableView.dataSource = self
        userSearchTableView.delegate = self
        initUserCell()
        //initSearchBar()
        retrieveProfiles()
        
        self.navigationItem.title = "User Search"
    }
    
//    func initSearchBar(){
//        searchBar = UISearchBar()
//        searchBar?.sizeToFit()
//        navigationItem.titleView = searchBar
//    }
    
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
        
        if searchActive {
            if filtered.count > 0 {
                cell.profile = filtered[indexPath.row]
            }
        }
        else {
            if profiles.count > 0 {
                cell.profile = profiles[indexPath.row]
            }
        }
        //cell.profile = profiles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return filtered.count
        }
        else {
            return profiles.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileViewController.profile = profiles[indexPath.row]
        self.navigationController!.pushViewController(profileViewController, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
}

extension UserSearchViewController: UISearchBarDelegate {
    
    //******  Search Bar functions
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        searchActive = true;
        self.userSearchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.view.endEditing(true)
        userSearchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        userSearchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar,  textDidChange searchText: String) {
        
        if(searchText=="") {
            filtered = profiles
        }
        else {
            filtered = profiles.filter({ (text) -> Bool in
                let tmp: NSString = text.fullName as String!
                let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        }
        
        print("Filtered count \(filtered.count) searchText = \(searchText)")

        
        if(filtered.count >= 0) {
            searchActive = true
        }
        
        self.userSearchTableView.reloadData()
    }
    
}