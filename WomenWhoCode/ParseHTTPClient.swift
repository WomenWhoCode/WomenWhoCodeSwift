//
//  HTTPClient.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ParseHTTPClient: BDBOAuth1SessionManager {
    //API KEYS
    let consumerKey = "Inu8PYBRAuy6eA4H9dPgjkoEX"
    let consumerSecret = "CdDFLjwwJmCYU1bJqfwsVJcj5TlzZdSApGzOBHOB0ssihZLD5w"
    let baseUrlString = "https://api.twitter.com/"
    
    var handleLoginCompletion: ((user: User?, error: NSError?) -> ())?
    var fetchTweetsCompletion: ((tweets: [Tweet]?, error: NSError?) -> ())?
    var fetchTweetCompletion: ((tweet: Tweet?, error: NSError?) -> ())?
    
    init(){
        let baseUrl = NSURL(string: baseUrlString)
        super.init(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
    }
    
    override init(baseURL url: NSURL!, sessionConfiguration configuration: NSURLSessionConfiguration!) {
        super.init(baseURL: url, sessionConfiguration: configuration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loginWithTwitter(completion: (user: User?, error: NSError?) -> Void){
        handleLoginCompletion = completion
        self.requestSerializer.removeAccessToken()
        self.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "vTweetz://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }, failure: { (error: NSError!) -> Void in
                self.handleLoginCompletion?(user: nil, error: error)
        })
    }
    
    func fetchAccessToken(urlQuery:String){
        self.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: urlQuery)!, success: { (accessToken:BDBOAuth1Credential!) -> Void in
            print("Got access token")
            self.requestSerializer.saveAccessToken(accessToken)
            self.fetchUser()
            }) { (error:NSError!) -> Void in
                self.handleLoginCompletion?(user: nil, error: error)
        }
    }
    
    func fetchUser(){
        self.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (session: NSURLSessionDataTask, response:AnyObject?) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            User.currentUser = user
            self.handleLoginCompletion?(user: user, error: nil)
            }) { (session: NSURLSessionDataTask?, error:NSError) -> Void in
                self.handleLoginCompletion?(user: nil, error: error)
        }
    }
    
    func fetchTweets(fetchUrl:String, parameters: NSDictionary, completion: (tweets: [Tweet]?, error: NSError?) -> Void){
        fetchTweetsCompletion = completion
        self.GET("1.1/statuses/\(fetchUrl)", parameters: parameters, progress: nil, success: { (session: NSURLSessionDataTask, response:AnyObject?) -> Void in
            if let timeline = response as? [NSDictionary]{
                let tweets = Tweet.tweetsWithArray(timeline)
                self.fetchTweetsCompletion?(tweets: tweets, error: nil)
            }
            }) { (session: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Error")
                self.fetchTweetsCompletion?(tweets: nil, error: error)
        }
    }
    
    func loadMoreTweets(fetchUrl:String, parameters: NSDictionary, completion: (tweets: [Tweet]?, error: NSError?) -> Void){
        fetchTweetsCompletion = completion
        self.GET("1.1/statuses/\(fetchUrl)", parameters: parameters, progress: nil, success: { (session: NSURLSessionDataTask, response:AnyObject?) -> Void in
            if let timeline = response as? [NSDictionary]{
                let tweets = Tweet.tweetsWithArray(timeline, maxId: parameters["max_id"] as? String)
                self.fetchTweetsCompletion?(tweets: tweets, error: nil)
            }
            }) { (session: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Error")
                self.fetchTweetsCompletion?(tweets: nil, error: error)
        }
    }
    
    
    func likeOnTweet(tweetId: String, action: String, completion: (tweet: Tweet?, error: NSError?) -> Void){
        fetchTweetCompletion = completion
        self.POST("1.1/favorites/\(action).json?id=\(tweetId)", parameters: nil, progress: nil, success: { (session: NSURLSessionDataTask, response:AnyObject?) -> Void in
            if let tweetDictionary = response as? NSDictionary{
                let tweet = Tweet(responseDictionary: tweetDictionary)
                self.fetchTweetCompletion?(tweet: tweet, error: nil)
            }
            }) { (session: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Error: \(error)")
                self.fetchTweetCompletion?(tweet: nil, error: error)
        }
    }
    
    func postOnTweet(postUrl:String, completion: (tweet: Tweet?, error: NSError?) -> Void){
        fetchTweetCompletion = completion
        self.POST("1.1/statuses/\(postUrl).json", parameters: nil, progress: nil, success: { (session: NSURLSessionDataTask, response:AnyObject?) -> Void in
            if let tweetDictionary = response as? NSDictionary{
                let tweet = Tweet(responseDictionary: tweetDictionary)
                self.fetchTweetCompletion?(tweet: tweet, error: nil)
            }
            }) { (session: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Error: \(error)")
                self.fetchTweetCompletion?(tweet: nil, error: error)
        }
    }
    
    func createTweet(postUrl: String, tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> Void){
        fetchTweetCompletion = completion
        var params = [String: String]()
        params["status"] = tweet.text
        if((tweet.inReplytoTweet) != nil){
            params["in_reply_to_status_id"] = tweet.inReplytoTweet
        }
        
        //        let tweetParams = "status=\(tweet.text)&in_reply_to_status_id=\(tweet.inReplytoTweet)"
        self.POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (session: NSURLSessionDataTask, response:AnyObject?) -> Void in
            if let tweetDictionary = response as? NSDictionary{
                let tweet = Tweet(responseDictionary: tweetDictionary)
                self.fetchTweetCompletion?(tweet: tweet, error: nil)
            }
            }) { (session: NSURLSessionDataTask?, error:NSError) -> Void in
                print("Error: \(error)")
                self.fetchTweetCompletion?(tweet: nil, error: error)
        }
        
    }
    
    
    func logout(){
        User.currentUser = nil
        self.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }

    
}
