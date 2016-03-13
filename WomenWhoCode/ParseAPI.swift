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
    
    private let httpClient: ParseAPIClient
    private let isOnline: Bool
    private let persistenceManager: PersistenceManager
    
    init(){
        httpClient = ParseAPIClient()
        isOnline = false
        persistenceManager = PersistenceManager()
    }
    
    func query(className: String){
        httpClient.query(className)
    }
    
    func create(object: PFObject, callback: PFBooleanResultBlock?){
        httpClient.create(object, callback: callback)
    }
    
    func getEvents(completion: (events: [Event]?, error: NSError?) -> ()) {
        httpClient.getEvents(completion)
    }
    
    func getEventWithEventId(objectID: String, completion: (event: Event?, error: NSError?) -> ()) {
        httpClient.getEventWithEventId(objectID, completion: completion)
    }
    
    func getProfiles(completion: (profiles: [Profile]?, error: NSError?) -> ()) {
        httpClient.getProfiles(completion)
    }
    
    func getProfileWithUserId (objectID: String, completion: (profile: Profile?, error: NSError?) -> ()) {
        httpClient.getProfileWithUserId(objectID, completion: completion)
    }
    
    
    func getFeatures(completion: (feature: [Feature]?, error: NSError?) -> ()) {
        httpClient.getFeatures(completion)
    }
    
    func getNetworkWithNetworkName (name: String, completion: (network: Network?, error: NSError?) -> ()) {
        httpClient.getNetworkWithNetworkName(name, completion: completion)
        
    }
    
    func getSubscriptions(completion: (subscribed: [Subscribed]?, error: NSError?) -> ()) {
        httpClient.getSubscriptions(completion)
    }
}

