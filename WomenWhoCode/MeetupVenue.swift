//
//  MeetupVenue.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import Foundation
/*
"venue": {
"id": 23953174,
"name": "AWS Loft",
"lat": 37.783287048339844,
"lon": -122.4084243774414,
"repinned": false,
"address_1": "925 Market Street",
"city": "San Francisco",
"country": "us",
"localized_country_name": "USA",
"zip": "",
"state": "CA"
},
}
*/
class MeetupVenue: NSObject {
    var venueId: String?
    var venueName: String?
    var lat: Double?
    var lon: Double?
    var repinned: Bool?
    var address1: String?
    var address2: String?
    var city: String?
    var country: String?
    var localizedCountryName: String?
    var zip: String?
    var state: String?
    
    init(dictionary: NSDictionary?){
        if let dict = dictionary{
            venueId = dict["id"] as? String
            venueName = dict["name"] as? String
            lat = dict["lat"] as? Double
            lon = dict["lon"] as? Double
            repinned = dict["repinned"] as? Bool
            address1 = dict["address_1"] as? String
            address2 = dict["address_2"] as? String
            city = dict["city"] as? String
            localizedCountryName = dict["localized_country_name"] as? String
            zip = dict["zip"] as? String
            state = dict["state"] as? String
        }
    }
    
    override var description: String{
        let addressArray = [address1, city, state, localizedCountryName]
        let cleanAddress = addressArray.flatMap { $0 }
        return cleanAddress.joinWithSeparator(", ")
    }
}
