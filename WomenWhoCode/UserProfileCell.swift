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

class UserProfileCell: UITableViewCell {
    
    var profileId: String?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var networkLabel: UILabel!
    @IBOutlet weak var featuresLabel: UILabel!
    
    var profile: Profile!{
        didSet{
            profileId = profile.objectId
            nameLabel.text = profile.fullName ?? " "
            networkLabel.text = profile.networkName! ?? " "
            
            if(profile.imageUrl != nil) {
                profileImage.setImageWithURL(NSURL(string: profile.imageUrl!)!)
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
