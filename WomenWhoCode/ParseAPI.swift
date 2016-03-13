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
        parseHttpClient.getEvents(completion)
    }
    
    func getProfiles(completion: (profiles: [Profile]?, error: NSError?) -> ()) {
        parseHttpClient.getProfiles(completion)
    }
    
    func getProfileWithUserId (objectID: String, completion: (profile: Profile?, error: NSError?) -> ()) {
    parseHttpClient.getProfileWithUserId(objectID, completion: completion)
    }
    

    func getFeatures(completion: (feature: [Feature]?, error: NSError?) -> ()) {
        parseHttpClient.getFeatures(completion)
    }

    func getNetworkWithNetworkName (name: String, completion: (network: Network?, error: NSError?) -> ()) {
        parseHttpClient.getNetworkWithNetworkName(name, completion: completion)

    }
}
