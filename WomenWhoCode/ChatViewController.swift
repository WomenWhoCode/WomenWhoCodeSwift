//
//  ChatViewController.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Foundation
import SlackTextViewController

class ChatViewController: SLKTextViewController {
    
    //CellID
    let messageCellId = "WWC_MessageCell"
    var channelId: String!
    
    var messages:[Message] = []
    var usersDict:[String:SlackUser] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMessageCell()
        getAllUsers()
    }
    
    func initMessageCell(){
        let cellNib = UINib(nibName: "MessageCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(cellNib, forCellReuseIdentifier: messageCellId)
        tableView.rowHeight = UITableViewAutomaticDimension //needed for autolayout
        tableView.estimatedRowHeight = 50.0 //needed for autolayout
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func getAllUsers(){
        print("Get all users")
        SlackAPI.sharedInstance.getUsersList(loadUsers)
    }
    
    func getMessages(){
        print("Get message for channel")
        SlackAPI.sharedInstance.getChannelHistory(channelId, successCallback: loadMessages)
    }
    
    func loadUsers(users: [SlackUser]){
        print("Loading Users")
        usersDict = SlackUser.arrayToDict(users)
        getMessages()
    }
    
    func loadMessages(messages: [Message]) {
        print("In load messages")
        self.messages = messages
        self.tableView.reloadData()
    }
    
    override func didPressRightButton(sender: AnyObject!) {
        SlackAPI.sharedInstance.writeToChannel(self.channelId, textString: self.textView.text) { (message) in
            self.messages.insert(message, atIndex: 0)
            self.tableView.reloadData()
        }
        super.didPressRightButton(sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableView Delegate
    // Return number of rows in the table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    // Create table view rows
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(messageCellId, forIndexPath: indexPath) as! MessageCell
            let message = self.messages[indexPath.row]
            cell.message = message
            cell.user = self.usersDict[message.userId!]
            cell.transform = self.tableView.transform;
            return cell
    }
}