//
//  ProfileViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import AFNetworking
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet var name: UILabel!
    @IBOutlet var jobDescription: UILabel!
    @IBOutlet var followingCount: UILabel!
    @IBOutlet var followersCount: UILabel!
    @IBOutlet var badges: UILabel!
    @IBOutlet var awesomeCount: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var networkImage: UIImageView!
    var loggedInUserId = "h0VjEs2aql"
    var profile: Profile! {
        didSet {
            name.text = profile.fullName
            jobDescription.text = profile.jobTitle
            followingCount.text = "\(profile!.followingCount!)"
            followersCount.text = "\(profile!.followersCount!)"
            badges.text = profile!.badges
            awesomeCount.text = "\(profile!.awesomeCount!)"
            profileImage.setImageWithURL(NSURL(string: profile.imageUrl!)!)
            networkImage.setImageWithURL(NSURL(string: profile.network.imageUrl!)!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(profile == nil) {
            ParseAPI.sharedInstance.getProfileWithUserId (loggedInUserId) { (profile, error) -> () in
                if error != nil {
                    print("Error retrieving logged in user from Parse")
                } else {
                    self.profile = profile
                }
            }
        }
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectionChanged(sender: UISegmentedControl) {
        
    }
    

}
