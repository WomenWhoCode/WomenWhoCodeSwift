//
//  UserSearchViewController.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class UserSearchViewController: UIViewController {
    
    @IBOutlet weak var userSearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUserSearch()
    }
    
    func initUserSearch(){
        let cellNib = UINib(nibName: "UserSearchTableViewCell", bundle: NSBundle.mainBundle())
        userSearchTableView.registerNib(cellNib, forCellReuseIdentifier: "WWC_UserSearchCell")
        userSearchTableView.estimatedRowHeight = 200
        userSearchTableView.rowHeight = UITableViewAutomaticDimension

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}