//
//  ProfileViewController.swift
//  WomenWhoCode
//
//  Created by Prasanthi Relangi on 2/29/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {

    @IBOutlet var name: UILabel!
    @IBOutlet var jobDescription: UILabel!
    @IBOutlet var followingCount: UILabel!
    @IBOutlet var followersCount: UILabel!
    @IBOutlet var badges: UILabel!
    @IBOutlet var awesomeCount: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var networkImage: UIImageView!
    var profile: Profile! {
        didSet {
            name.text = profile.fullName
            jobDescription.text = profile.jobTitle
            followingCount.text = "\(profile.followingCount)"
            followersCount.text = "\(profile.followersCount)"
            badges.text = profile.badges
            awesomeCount.text = "\(profile.awesomeCount)"
            profileImage.setImageWithURL(NSURL(string: profile.imageUrl!)!)
            networkImage.setImageWithURL(NSURL(string: profile.network.imageUrl!)!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = "Test User"
        jobDescription.text = "Software Developer"
        badges.text = ""
        profileImage.setImageWithURL(NSURL(string: "https://www.filepicker.io/api/file/TO9j8U0uRpa8UtpOQf7l")!)
        networkImage.setImageWithURL(NSURL(string: "https://www.filepicker.io/api/file/GTduf9H3RyyXW8YGxpv9")!)

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSelectionChanged(sender: UISegmentedControl) {
        
    }
    

}
