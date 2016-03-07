//
//  ParseClient.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse


class ParseAPI{
    
    static let sharedInstance = ParseAPI()
    
    private let parseHttpClient: ParseHTTPClient
    private let isOnline: Bool
    private let persistenceManager: PersistenceManager
    
    init(){
        parseHttpClient = ParseHTTPClient()
        isOnline = false
        persistenceManager = PersistenceManager()
    }
    
    func query(className: String){
        parseHttpClient.query(className)
    }
    
    func create(object: PFObject, callback: PFBooleanResultBlock?){
        parseHttpClient.create(object, callback: callback)
    }
    
    func getEvents(completion: (events: [Event]?, error: NSError?) -> ()) {
        parseHttpClient.getEvents { (events, error) -> () in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(events!.count) scores.")
                completion(events: events, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion(events: nil, error: error)
            }

        }
    }
    
    
    
}
