//
//  MessageCell.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import ActiveLabel
import Emoji

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var message: Message!{
        didSet{
            messageLabel.text = message.text!.emojiUnescapedString
            timestampLabel.text = message.timestamp
        }
    }
    
    func getArray(string: String){
        let string = "asdasdasd <@U0PBN2ESY|vinu> asdasdasda"
        let origString = string as NSString
        
        let attributedString = NSMutableAttributedString(string: string)
        
        let slackUserPairRegex = try? NSRegularExpression(pattern: "(?:^|\\s|$)<@[a-z0-9_]*\\|[a-z0-9_]*>", options: [.CaseInsensitive])
        let userPairMatches = slackUserPairRegex!.matchesInString(string, options: [], range: NSMakeRange(0, attributedString.length))
        
        
        
        for userPairMatch in userPairMatches
        {
            let wordRange = userPairMatch.rangeAtIndex(0)
            let userPair = origString.substringWithRange(wordRange)
            let attributedUser =  NSMutableAttributedString(string: userPair)
            
            let userPattern = try? NSRegularExpression(pattern: "(?:^|\\s|>|$)([a-z0_9]*)>", options: [.CaseInsensitive])
            
            let userMatches = userPattern!.matchesInString(userPair, options: [], range: NSMakeRange(0, attributedUser.length))
            for userMatch in userMatches{
                let userRange = userMatch.rangeAtIndex(0)
                print("TB")
                print((userPair as NSString).substringWithRange(userRange))
                print("TA")
            }
            
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: wordRange)
        }
        print("ATTR: \(attributedString)")
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
