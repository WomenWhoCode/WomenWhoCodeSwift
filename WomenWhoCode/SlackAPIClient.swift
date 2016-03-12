//
//  SlackAPIClient.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/11/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import OAuthSwift

class SlackAPIClient {
    let clientId = "23398940453.26339368899"
    let clientSecret = "143fc69c2b2c1007d1aa55f40c4d5e7b"
    var oauthswift:OAuth2Swift?
    var oauthToken = ""
    
    
    init(){
        let baseUrl = NSURL(string: "https://slack.com/")
        //        super.init(baseURL: baseUrl, consumerKey: clientId, consumerSecret: clientSecret)
    }
    
    func readGen(){
        oauthswift!.client.get("https://slack.com/api/channels.history",
            parameters: ["token": oauthToken, "channel": "C0PBTN49W"],
            success: {
                data, response in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                print(dataString)
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
            scope: "channels:read,channels:history", state:"SLACK",
            success: { credential, response, parameters in
                print("credential: \(credential)")
                self.oauthToken = credential.oauth_token
                print(credential.oauth_token)
                self.readGen()
            },
            failure: { error in
                print(error.localizedDescription, terminator: "")

            }
        )
    }
}
