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
    var features = ["ios, mobile","ruby, mobile, backend", "android, java, mobile","java","javascript, css","html, css","backend, db, sql","scala,  ruby","cucumber, automated testing , appium","c # , api , backend", "c++, gaming" , "security, sql"]
    
    var profile: Profile!{
        didSet{
            profileId = profile.objectId
            nameLabel.text = profile.fullName ?? " "
            networkLabel.text = profile.networkName! ?? " "
            
            if let imageURL = profile.imageUrl {
                //print("profileName: \(nameLabel.text) imageURL: \(profile.imageUrl)")
                profileImage.setImageWithURL(NSURL(string: imageURL)!)
            }
            else {
                profileImage.image = UIImage(named:"default_user_icon")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let randomIndex = Int(arc4random_uniform(UInt32(features.count)))
        featuresLabel.text = features[randomIndex]
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
