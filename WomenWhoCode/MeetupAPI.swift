//
//  MeetupAPI.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/13/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//


import UIKit


class MeetupAPI{
    
    static let sharedInstance = MeetupAPI()
    
    private let httpClient: MeetupAPIClient
    private let isOnline: Bool
    
    init(){
        httpClient = MeetupAPIClient()
        httpClient.getOauthTokenFromUser()
        isOnline = false
    }
    
    func login(){
        print("Login in meetupapi client")
        httpClient.login()
    }
    
    func fetchGroup(successCallback: (MeetupGroup) -> Void){
        httpClient.fetchGroup(successCallback: successCallback)
    }
    
    func fetchEvent(urlParams: [String:String], successCallback: (MeetupEvent) -> Void){
        httpClient.fetchEvent(urlParams, successCallback: successCallback)
    }
    
    func fetchEventRsvps(urlParams: [String: String], successCallback: ([MeetupMember]) -> Void){
        httpClient.fetchEventRsvps(urlParams, successCallback: successCallback)
    }
    
    
}
