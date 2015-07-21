//
//  MyPollsViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse

class MyPollsViewController: UIViewController {
    
    // MARK: - Section: Class Properties
    
    @IBOutlet weak var tableView: UITableView!
    var polls: [Poll] = []
    
    // MARK: - Section: Class Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let pollsFromThisUser = Poll.query()
        pollsFromThisUser?.whereKey("user", equalTo: PFUser.currentUser()!)
        pollsFromThisUser?.includeKey("user")
        pollsFromThisUser?.orderByDescending("createdAt")
        
        pollsFromThisUser?.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
            self.polls = result as? [Poll] ?? []
            self.tableView.reloadData()
            //println(self.polls)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


// MARK: - Protocols
// MARK: UITableViewDataSource

extension MyPollsViewController:UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return polls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myPollCell", forIndexPath: indexPath) as! MyPollsTableViewCell
        
        cell.title.text = polls[indexPath.row].title
        cell.username.text = "By: \(polls[indexPath.row].user!.username!) " //CHECK for nil
        cell.categoryImage.image = UIImage(named:Poll.getCategoryImageString(polls[indexPath.row].category))
        
        return cell
        
    }
    
}
