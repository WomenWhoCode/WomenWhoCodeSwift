//
//  LoginViewController.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/5/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit;
import Parse;

class LoginViewController: UIViewController {

    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: UIButton) {
        let uname = username.text ?? ""
        let pwd = password.text ?? ""
        
        PFUser.logInWithUsernameInBackground(uname, password: pwd) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                print("User login failed.")
                print(error.localizedDescription)
            } else {
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
            }
        }
    }
   

}
