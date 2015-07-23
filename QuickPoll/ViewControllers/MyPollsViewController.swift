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
    var poll:Poll?
    
    // MARK: - Section: Class Methods
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseHelper.timelineRequestForCurrentUser { (result, error) -> Void in
            if error == nil {
                self.polls = result as? [Poll] ?? []
                self.tableView.reloadData()
                
            } else {
                println("Error loading data from parse: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showExistingPoll" {
            let voteViewController = segue.destinationViewController as! VoteViewController
            voteViewController.polls = poll
        }
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
        
        if let pollChecked = polls[indexPath.row].votedFor{
            
            if pollChecked {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
        } else {
            polls[indexPath.row].fetchVotedPolls({ (success, error) -> Void in
                if success {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
            })
        }
        cell.tintColor = UIColor(red: 82/255.0, green: 193/255.0, blue: 159/255.0, alpha: 0.80)

        return cell
    }
    
    
}

extension MyPollsViewController:UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        poll = polls[indexPath.row]
        self.performSegueWithIdentifier("showExistingPoll", sender: self)
    }
    
}