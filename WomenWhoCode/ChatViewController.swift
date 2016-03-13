//
//  ChatViewController.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/12/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import SlackTextViewController


class ChatViewController: SLKTextViewController {

    @IBOutlet weak var chatTableView: UITableView!
    
    //CellID
    let messageCellId = "WWC_MessageCell"
    
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func initCell(){
        let cellNib = UINib(nibName: "MessageCell", bundle: NSBundle.mainBundle())
        chatTableView.registerNib(cellNib, forCellReuseIdentifier: messageCellId)
        chatTableView.estimatedRowHeight = 200
        chatTableView.rowHeight = UITableViewAutomaticDimension
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            cell.message = self.messages[indexPath.row]
            return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}