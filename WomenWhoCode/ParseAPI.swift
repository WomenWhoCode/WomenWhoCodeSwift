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
    
    func query(objectName: String){
        parseHttpClient.query(objectName)
    }
    
    func create(object: PFObject, callback: PFBooleanResultBlock?){
        parseHttpClient.create(object, callback: callback)
    }
}
