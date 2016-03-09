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
    
    var profile: Profile!{
        didSet{
            nameLabel.text = profile.fullName ?? " "
            networkLabel.text = profile.network.title! ?? " "
            //FixMe: Update the label name and some other columns of user to match Parse
            awesomeCountLabel.text = "\(profile.awesomeCount ?? 0)"
            
//            profileImage.setImageWithURL(NSURL(string: profile.imageUrl!)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
