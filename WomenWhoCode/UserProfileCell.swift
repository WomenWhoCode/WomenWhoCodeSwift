//
//  UserSearchTableViewCell.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import AFNetworking

class UserProfileCell: UITableViewCell {

    

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var featuresLabel: UILabel!
    @IBOutlet weak var awesomeImage: UIImageView!
    @IBOutlet weak var awesomeCountLabel: UILabel!
    
    @IBOutlet weak var followersCount: UILabel!
    
    
    @IBAction func onFollow(sender: AnyObject) {
        
        
        
    }
    
    
    var profile: Profile!{
        didSet{
            nameLabel.text = profile.fullName ?? " "
            networkLabel.text = profile.networkName! ?? " "
//            FixMe: Update the username and features label  
            
            if let awesomeCount = profile.awesomeCount {
                awesomeCountLabel.text = "\(profile.awesomeCount!)"
            }
            else {
                awesomeCountLabel.text = "0"
            }
            
            if(profile.imageUrl != nil) {
            profileImage.setImageWithURL(NSURL(string: profile.imageUrl!)!)
            }
            
            if let followCount = profile.followersCount {
                followersCount.text = " \(followCount) followers"
            }
            else {
                followersCount.text = "No followers yet"
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
