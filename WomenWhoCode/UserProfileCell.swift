//
//  UserSearchTableViewCell.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import AFNetworking
import Parse

protocol UserProfileCellDelegate {
    func userProfileCell(userProfileCell: UserProfileCell, onFollow followButtonSet: Bool)
}

class UserProfileCell: UITableViewCell {
    
    var profileId: String?
    var delegate: UserProfileCellDelegate?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var featuresLabel: UILabel!
    @IBOutlet weak var awesomeImage: UIImageView!
    @IBOutlet weak var awesomeCountLabel: UILabel!
    
    @IBOutlet weak var followersCount: UILabel!
    
    
    @IBAction func onFollow(sender: AnyObject) {
        
        //Increment followersCount
        print("Profile name: \(profile.fullName!) objectId: \(profile.objectId!)")
        
        let predicate = NSPredicate(format:"objectId == '\(profileId!)'")
        let query = PFQuery(className: "Profile", predicate: predicate)
        
        //FIXME: prelangi : Refactor this code!!
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) profiles.")
                
                if let objects = objects {
                    for object in objects {
                        //self.profile.followersCount = self.profile.followersCount! + 1
                        print("Updating followers count of \(self.profile.fullName!)")
                        object["followers_count"] = self.profile.followersCount!+1
                        object.saveInBackground()
                        
                        self.delegate?.userProfileCell(self, onFollow: true)
                    }
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error!)")
                
                
                
            }
        }
        
        
        
    }
    
    
    var profile: Profile!{
        didSet{
            profileId = profile.objectId
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
