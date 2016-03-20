//
//  TimelineCell.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import ActiveLabel

protocol TimelineCellDelegate {
    func timelineCellDelegate(sender: TimelineCell, onApplaud: Bool)
}

class TimelineCell: UITableViewCell {
    @IBOutlet var topicTitle: UILabel!

    @IBOutlet var topicView: UIView!
    
    @IBOutlet weak var awesomeButton: UIButton!
    
    @IBOutlet var postDesc: ActiveLabel!
  
    @IBOutlet var topicImage: UIImageView!
    
    @IBOutlet weak var awesomeImageView: UIImageView!
    
    @IBOutlet weak var awesomeCountLabel: UILabel!
    
    var delegate: TimelineCellDelegate?
    var applauded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onApplaud(sender: AnyObject) {
        
        applauded = !applauded
        var imageArray: [UIImage] = [];
        let defaultImage = UIImage(named: "awesome.png")
        let finalImage = UIImage(named: "awed_d-7.png")
        
        for index in 1...7 {
            let imageName = "awed_d-\(index).png"
            let image = UIImage(named: imageName)
            imageArray.append(image!)
        }
        
        awesomeButton.setImage(finalImage, forState: UIControlState.Normal)
        
        
        awesomeButton.imageView?.animationRepeatCount = 1
        awesomeButton.imageView?.animationImages = imageArray
        awesomeButton.imageView?.animationDuration = 0.5
        awesomeButton.imageView?.startAnimating()
        
        //Let the timeline table view know that the awesomecount has been updated
        delegate?.timelineCellDelegate(self, onApplaud: applauded)

    }

}
