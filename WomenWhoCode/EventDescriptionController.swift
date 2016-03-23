//
//  EventDescriptionController.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class EventDescriptionController: UIViewController {

    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var descriptionText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 1.5
        scrollView.contentSize = CGSizeMake(contentWidth, contentHeight)
        setMeetupDescription()
    }
    
    func setMeetupDescription(){
        do{
            let attrStr = try NSAttributedString(
                data: (descriptionText.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!),
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            eventDescription.attributedText = attrStr
        }catch{
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
