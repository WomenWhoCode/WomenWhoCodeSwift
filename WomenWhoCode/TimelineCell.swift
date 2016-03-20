//
//  TimelineCell.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import ActiveLabel

class TimelineCell: UITableViewCell {
    @IBOutlet var topicTitle: UILabel!

    @IBOutlet var topicView: UIView!
    
    @IBOutlet weak var awesomeButton: UIButton!
    
    @IBOutlet var postDesc: ActiveLabel!
  
    @IBOutlet var topicImage: UIImageView!
    
    @IBOutlet weak var awesomeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
