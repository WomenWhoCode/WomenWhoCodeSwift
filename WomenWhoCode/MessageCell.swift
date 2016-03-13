//
//  MessageCell.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import ActiveLabel

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var message: Message!{
        didSet{
            messageLabel.text = message.text
        }
    }
    
    var user: SlackUser!{
        didSet{
            nameLabel.text = user.name
            userImage.setImageWithURL(NSURL(string:user.image48!)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = Constants.Color.Teal.dark
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
