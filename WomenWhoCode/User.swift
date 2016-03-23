//
//  User.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"
class User: NSObject {
    
    var objectId: String?
    var profile: Profile?
    var username : String?  //will contain the complete event time details (month,date and time)
    var updatedAt: NSDate?
    var email: String? //description is already present in the super class and gives an error
    var slackAuthToken: String?
    var meetupAuthToken: String?
    
    override init() {
        
        //FIXME: Temporary initialization
        objectId = "e7HoAPrwQk"
        profile = Profile()
        username = "test"
        updatedAt = NSDate(timeIntervalSinceNow: 20)
        email  = "test@test.com"
        slackAuthToken = ""
        meetupAuthToken = ""
    }
    
    init(basic: Bool){
        //FIXME: Temporary initialization
        objectId = "e7HoAPrwQk"
        username = "test"
        email  = "test@test.com"
        slackAuthToken = ""
        meetupAuthToken = ""
    }
    
    init(dictionary: NSDictionary) {
        objectId = dictionary["objectId"] as? String
        profile = dictionary["profile"] as? Profile
        updatedAt = dictionary["updatedAt"] as? NSDate
        username = dictionary["username"] as? String
        email = dictionary["email"] as? String
        slackAuthToken = dictionary["slackAuthToken"] as? String
        meetupAuthToken = dictionary["meetupAuthToken"] as? String
    }
    
    init(object: PFObject) {
        objectId = object["objectId"] as? String
        profile = object["profile"] as? Profile
        updatedAt = object["updatedAt"] as? NSDate
        username = object["username"] as? String
        email = object["email"] as? String
        slackAuthToken = ""
        meetupAuthToken = ""
    }
    
    func hasSlackAuth() -> Bool{
        return self.slackAuthToken?.characters.count > 0
    }
    
    func hasMeetupAuth() -> Bool{
        return self.meetupAuthToken?.characters.count > 0
    }
    
    func getDictionary() -> NSDictionary{
        return ["objectId":self.objectId!,
                "username": self.username!,
                "email": self.email!,
                "slackAuthToken": self.slackAuthToken!,
                "meetupAuthToken": self.meetupAuthToken!
        ]
    }
    
    class var currentUser: User? {
        get{
            if _currentUser == nil{
                
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if let userData = data {
                    do{
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(userData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        _currentUser = User(dictionary: dictionary!)
                    }catch let error as NSError{
                        _currentUser = nil
                        print("JSON Parsing in userdefaults threw an error: \(error)")
                    }
                }
                
            }
            return _currentUser
        }
        
        
        set(user){
            _currentUser = user
            if _currentUser != nil {
                do{
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.getDictionary(), options: NSJSONWritingOptions.PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                }catch let error as NSError{
                    NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                    print("JSON Parsing in userdefaults threw an error: \(error)")
                }
                
            }else{
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

}