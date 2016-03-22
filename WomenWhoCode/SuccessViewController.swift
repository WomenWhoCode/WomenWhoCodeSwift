//
//  SuccessViewController.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/5/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class SuccessViewController: UIViewController {

    @IBOutlet var messageLabel: UILabel!
    var message : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       PFUser.logOut()
    }

    @IBAction func meetupConnectTap(sender: UIButton) {
        print("User tried to connect with meetup")
    }

    @IBAction func slackConnectTap(sender: UIButton) {
        print("User tried to connect with slack")
    }
}
