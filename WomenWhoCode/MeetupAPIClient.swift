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
        let requestUrl = "\(baseUrl)/\(urlParams["urlName"])/events/\(["eventId"])"
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
    
    func readGen(succesCallback: ([Message]) -> Void){
        oauthswift!.client.get("https://slack.com/api/channels.history",
            parameters: ["token": oauthToken, "channel": "C0PBTN49W"],
            success: {
                data, response in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let dataFromString = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let jsonData = JSON(data: dataFromString)
                    //If json is .Dictionary
                    for (key,json):(String, JSON) in jsonData {
                        if (key == "messages"){
                            let messages = Message.initWithJSONArray(json.array!)
                            succesCallback(messages)
                        }
                    }
                }
            }
            , failure: { error in
                print(error)
            }
        )
    }
    
    func login(){
        oauthswift = OAuth2Swift(
            consumerKey:    clientId,
            consumerSecret: clientSecret,
            authorizeUrl:   "https://slack.com/oauth/authorize",
            accessTokenUrl: "https://slack.com/api/oauth.access",
            responseType:   "code"
        )
        oauthswift!.authorizeWithCallbackURL(
            NSURL(string: "womenwhocode://oauth-callback/slack")!,
            scope: "channels:read,channels:history,users:read", state:"SLACK",
            success: { credential, response, parameters in
                self.oauthToken = credential.oauth_token
            },
            failure: { error in
                print(error.localizedDescription, terminator: "")
                
            }
        )
    }
}
