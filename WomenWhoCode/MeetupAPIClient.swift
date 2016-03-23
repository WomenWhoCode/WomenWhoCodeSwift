//
//  MeetupAPIClient.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
// This APIClient is a public one to retrieve event details only
//

import Foundation
import OAuthSwift
import SwiftyJSON
import Alamofire

class MeetupAPIClient {
    
    let clientId = "23398940453.26339368899"
    let clientSecret = "143fc69c2b2c1007d1aa55f40c4d5e7b"
    var oauthswift:OAuth2Swift?
    var oauthToken = ""
    let baseUrl = "https://api.meetup.com"
    var parameters:[String:String] = ["sign": "true", "key": Constants.Api.Meetup.apiKey]
    
    //Get Event Group
    func fetchGroup(groupName: String = "Women-Who-Code-SF", successCallback: (MeetupGroup) -> Void){
        let requestUrl = "\(baseUrl)/\(groupName)"
        
        Alamofire.request(.GET, requestUrl, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("Validation Successful")
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        //Create meetupGroup
                    }
                case .Failure(let error):
                    print("Error in MeetupFetchGroup: \(error)")
                }
        }
    }
    
    func fetchEvent(urlParams: [String: String], successCallback: (MeetupEvent) -> Void){
        let requestUrl = "https://api.meetup.com/Women-Who-Code-SF/events/227524966"
        //        let requestUrl = "\(baseUrl)/\(urlParams["urlName"])/events/\(["eventId"])"
        Alamofire.request(.GET, requestUrl, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let JSON = response.result.value as? NSDictionary {
                        let event = MeetupEvent(dict: JSON)
                        successCallback(event)
                    }
                case .Failure(let error):
                    print("Error in MeetupFetchEvent: \(error)")
                }
        }
    }
    
    func fetchEventRsvps(urlParams: [String: String], successCallback: ([MeetupMember]) -> Void){
        let requestUrl = "https://api.meetup.com/Women-Who-Code-SF/events/227524966/rsvps"
        //        let requestUrl = "\(baseUrl)/\(urlParams["urlName"])/events/\(["eventId"])"
        Alamofire.request(.GET, requestUrl, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let JSON = response.result.value as? [NSDictionary] {
                        let members = MeetupMember.initWithArray(JSON)
                        successCallback(members)
                    }
                case .Failure(let error):
                    print("Error in fetchEventRsvp: \(error)")
                }
        }
        
    }
    
    
    func getUser(){
        let requestUrl = "https://api.meetup.com/2/member/self/?access_token=\(self.oauthToken)"
        Alamofire.request(.GET, requestUrl, parameters: parameters)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print(response.result.value)
                case .Failure(let error):
                    print("Error in fetchEventRsvp: \(error)")
                }
        }
    }
    
    
    //Logged in User Functions ***********************************************************************
    
    func login(){
        print("MeetupLogin Connect LOGIN")
        print("AUTH BEFOERE: \(self.oauthToken)")
        oauthswift = OAuth2Swift(
            consumerKey:    Constants.Api.Meetup.Consumer.key,
            consumerSecret: Constants.Api.Meetup.Consumer.secret,
            authorizeUrl:   "https://secure.meetup.com/oauth2/authorize",
            accessTokenUrl: "https://secure.meetup.com/oauth2/access",
            responseType:   "code"
        )
        oauthswift!.authorizeWithCallbackURL(
            NSURL(string: "womenwhocode://oauth-callback/meetup")!,
//            scope: "basic, group_join_edit, profile_edit, reporting, rsvp", state:"MEETUP",
            scope: "profile_edit rsvp ageless reporting", state:"MEETUP",
            success: { credential, response, parameters in
                self.oauthToken = credential.oauth_token
                print("Meetup Auth token: \(self.oauthToken)")
                self.getUser()
            },
            failure: { error in
                print(error.localizedDescription, terminator: "")
                
            }
        )
    }
    
    //Logged in User Functions ***********************************************************************
}