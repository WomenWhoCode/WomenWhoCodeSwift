//
//  TopicCell.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

protocol TopicCellDelegate {
    func topicCellDelegate(sender: TopicCell, onFollow: Bool)
}

class TopicCell: UITableViewCell {

    @IBOutlet var topicName: UILabel!
    @IBOutlet var followImage: UIImageView!
    @IBOutlet var topicImage: UIImageView!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var topicCellView: UIView!
    var delegate: TopicCellDelegate?
    
    
    var feature : Feature! {
        didSet {
            topicName.text = feature.title!
            if(feature.image_url != nil) {
                topicImage.setImageWithURL(NSURL(string:feature.image_url!)!)
            } else {
                topicImage.image = UIImage(named: "languages")
            }
            topicCellView.backgroundColor = UIColor(hexString: feature.hex_color!)
            
            //self.backgroundColor = UIColor(hexString: feature.hex_color!)
        }
    }
    
    
    
    @IBAction func onFollow(sender: AnyObject) {
        delegate?.topicCellDelegate(self, onFollow: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
