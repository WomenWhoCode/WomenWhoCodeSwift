//
//  TimelineCell.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    @IBOutlet var topicTitle: UILabel!

    @IBOutlet var topicView: UIView!
    
    
    @IBOutlet var postDesc: UILabel!
  
    @IBOutlet var topicImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
