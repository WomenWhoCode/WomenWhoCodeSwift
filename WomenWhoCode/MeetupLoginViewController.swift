//
//  MeetupLoginViewController.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/22/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit

class MeetupLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onMeetupConnect(sender: UIButton) {
        print("User tried to connect in MeetupLogin Connect")
    }
    
    @IBAction func onCloseTap(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
