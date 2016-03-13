//
//  SlackAPI.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit


class SlackAPI{
    
    static let sharedInstance = SlackAPI()
    
    private let httpClient: SlackAPIClient
    private let isOnline: Bool
    
    init(){
        httpClient = SlackAPIClient()
        isOnline = false
    }
    
    func login(){
        httpClient.login()
    }
    
    func getMessages(successCallback: ([Message]) -> Void) {
        httpClient.readGen(successCallback)
    }
    
    
    //Channels
    func getChannelsList(successCallback:([SlackChannel])->Void){
        httpClient.getChannelsList(successCallback)
    }
    
    func getChannelsInfo(channelId: String, successCallback:(SlackChannel)->Void){
        httpClient.getChannelsInfo(channelId, successCallback: successCallback)
    }
    
    func getUsersList(successCallback:([SlackUser])->Void){
        httpClient.getUsersList(successCallback)
    }
    
    func getChannelHistory(channelId: String, successCallback: ([Message]) -> Void){
        httpClient.getChannelHistory(channelId, successCallback: successCallback)
    }

    
    
}