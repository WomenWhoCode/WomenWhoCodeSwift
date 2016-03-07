//
//  Network.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//
import UIKit
import Parse

// DB name for CHAPTER
class Network: NSObject {
    
    var objectId: String?
    var imageUrl: String?
    var meetUpUrl : String?
    var title: String?
    var PFLocation : PFGeoPoint?
    
    //Derived properties
    
    var location : CLLocationCoordinate2D?
    
       override init() {
  
        //FIXME: Temporary initialization
        objectId = "TUiDFpXFc2"
        imageUrl = "https://www.filepicker.io/api/file/GTduf9H3RyyXW8YGxpv9"
        meetUpUrl = "http://www.meetup.com/Women-Who-Code-Atlanta"
        title = "Atlanta"
        PFLocation = PFGeoPoint()
    }
    
    init(dictionary: NSDictionary) {
        objectId = dictionary["objectId"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        meetUpUrl = dictionary["meetUpUrl"] as? String
        title = dictionary["title"] as? String
        PFLocation = dictionary["PFLocation"] as? PFGeoPoint
    }
    
    init(object: PFObject) {
        
        title = object["title"] as? String
        objectId = object["objectId"] as? String
        imageUrl = object["image_url"] as? String
        meetUpUrl = object["meetup_url"] as? String
        PFLocation = object["PFLocation"] as? PFGeoPoint
        
    }
    
    func convertGeoPointToLocation () -> CLLocationCoordinate2D {
        
        location = CLLocationCoordinate2D()
        
        /*
        TO CONVERT GEOPOINT TO CLLocationCoordinate2D :
        
        var descLocation: PFGeoPoint = PFGeoPoint()
        
        var innerP1 = NSPredicate(format: "ObjectID = %@", objectID)
        var innerQ1:PFQuery = PFQuery(className: "Test", predicate: innerP1)
        
        var query = PFQuery.orQueryWithSubqueries([innerQ1])
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock {
        (objects: [AnyObject]!, error: NSError!) -> Void in
        
        if error == nil {
        for object in objects {
        descLocation = object["GeoPoint"] as PFGeoPoint
        }
        } else {
        println("Error")
        }
        
        }
        
        
        And in your class where you need the location, just add these line:
        
        var latitude: CLLocationDegrees = descLocation.latitude
        var longtitude: CLLocationDegrees = descLocation.longitude
        
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        
        
        So you can add annotation to your map using this code:
        
        @IBOutlet var map: MKMapView!
        var annotation = MKPointAnnotation()
        annotation.title = "Test"
        annotation.coordinate = location
        map.addAnnotation(annotation)
        
        
        */
        return location!

    }
}