//
//  HTTPClient.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class ParseAPIClient{
    
    //API KEYS
    
    var appId = "sW8VXwGAEeq8FYaKMgcbPfliodb8XA7wx0QXLdx9"
    var clientKey = "HTVvl8X9szeaOlXzI8jEUx0MENGlzDTrCIrPCnIy"
    
    init(){
        Parse.setApplicationId(appId, clientKey: clientKey)
    }
    
    func query(className: String) -> PFQuery{
        return PFQuery(className: className)
    }
    
    func create(parseObject: PFObject, callback: PFBooleanResultBlock?){
        parseObject.saveInBackgroundWithBlock(callback)
    }
    
    //Events *****************************************************************************
    
    func getEventsByFilter(networks: [Network]?, features: [Feature]?,completion: (events: [Event]?, error: NSError?) -> ()) {
        
        let query = PFQuery(className:"Event")
        
//        query.whereKey("feature", containedIn: features!)
//        query.whereKey("network", containedIn: networks!)
//        
        query.includeKey("feature")
        query.includeKey("network")
        getEventList(query, completion: completion)
    }
    
    func getEvents(completion: (events: [Event]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Event")
        query.includeKey("network")
        query.includeKey("feature")
        getEventList(query, completion: completion)
    }
    
    func getEventList(query: PFQuery, completion: (events: [Event]?, error: NSError?) -> ()){
        var events: [Event] = []
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let event = Event(object: object)
                        events.append(event)
                    }
                }
                completion(events: events, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(events: nil, error: error)
            }
        }
    }
    
    func getEventWithEventId(objectID: String, completion: (event: Event?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Event")
        query.includeKey("network")
        query.includeKey("feature")
        query.whereKey("objectId", equalTo: objectID)

        var event: Event?
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        event = Event(object: object)
                    }
                }
                completion(event: event, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(event: nil, error: error)
            }
        }
        
    }
    
    //UserEvents ******************************************************************
    
    func getEventsForUser(userId: String, completion: (events: [Event]?, error: NSError?) -> ()){
        let userEventsquery = PFQuery(className: "UserEvents")
        userEventsquery.whereKey("user_id", equalTo: userId)
        var eventIds:[String] = []
        userEventsquery.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects {
                    for object in objects {
                        eventIds.append(object["event_id"] as! String)
                    }
                    //Get Events for the list
                    let query = PFQuery(className:"Event")
                    query.includeKey("network")
                    query.includeKey("feature")
                    query.whereKey("objectId", containedIn: eventIds)
                    self.getEventList(query, completion: completion)
                }
            }else {
                print("Error in getEventIdsForUser: \(error!)")
                completion(events: nil, error: error)
            }
        }
    }
    
    

    
    //Network ***********************************************************************
    
    func getNetworkWithNetworkName (name: String, completion: (network: Network?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Network")
        var network: Network?
        query.whereKey("title", equalTo: name)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        network = Network(object: object)
                    }
                }
                completion(network: network, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(network: nil, error: error)
            }
        }
        
    }
    
    func getNetworks(completion: (networks: [Network]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Network")
        query.orderByAscending("title")
        var networks: [Network] = []

        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let network = Network(object: object)
                        networks.append(network)
                    }
                }
                completion(networks:networks, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(networks: nil, error: error)
            }
        }
        
    }
    
    //Profiles ***********************************************************************
    
    func getProfiles(completion: (profiles: [Profile]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Profile")
        var profiles: [Profile] = []
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let profile = Profile(object: object)
                        profiles.append(profile)
                    }
                }
                completion(profiles: profiles, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(profiles: nil, error: error)
            }
        }
        
    }
    
    func getProfileWithUserId (objectID: String, completion: (profile: Profile?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Profile")
        var profile: Profile?
        query.whereKey("user_id", equalTo: objectID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        profile = Profile(object: object)
                    }
                }
                completion(profile: profile, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(profile: nil, error: error)
            }
        }
        
    }
    
    
    //Posts ***********************************************************************
    
    func getPosts(completion: (posts: [Post]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Post")
        var posts: [Post] = []
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let post = Post(object: object)
                        posts.append(post)
                    }
                }
                completion(posts: posts, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(posts: nil, error: error)
            }
        }
        
    }
    
    //Subscriptions ***********************************************************************
    
    func getSubscriptions(completion: (subscribed: [Subscribed]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Subscribe")
        var subscriptions: [Subscribed] = []
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let subscribe = Subscribed(object: object)
                        subscriptions.append(subscribe)
                    }
                }
                completion(subscribed: subscriptions, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(subscribed: nil, error: error)
            }
        }
        
    }

    
    //Features ***********************************************************************
    
    func getFeatures(completion: (features: [Feature]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Feature")
        var features: [Feature] = []
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let feature = Feature(object: object)
                        features.append(feature)
                    }
                }
                completion(features: features, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(features: nil, error: error)
            }
        }
        
    }

}
