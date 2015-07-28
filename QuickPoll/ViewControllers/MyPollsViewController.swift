//
//  MyPollsViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse



//Implementation of pollDelegate
class MyPollsViewController: UIViewController {
    
    // MARK: - Section: Class Properties
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentView: UISegmentedControl!
    var polls: [Poll] = []
    
    var pollFeed: [Poll] = []
    var myPolls: [Poll] = []
    var votedPolls: [Poll] = []
    
    var delegate: pollDelegate?
    
    var poll:Poll?
    
    
    // MARK: - Section: Class Methods
    
    @IBAction func changeFeedSource(sender: UISegmentedControl) {
        
        updateFeedData(sender.selectedSegmentIndex)
    }
    
    func updateFeedData (segmentIndex:Int) {
        
        switch segmentIndex {
            
        case 0:
            println("Poll Feed")
            polls = pollFeed
            tableView.reloadData()
            
        case 1:
            println("My Polls")
            polls = myPolls
            tableView.reloadData()
            
        case 2:
            println("Voted")
            polls = votedPolls
            tableView.reloadData()
            
        default:
            println("error")
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateFeedData(segmentView.selectedSegmentIndex)
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseHelper.timelineRequestForAllPolls { (result, error) -> Void in
            if error == nil {
                self.polls = result as? [Poll] ?? []
                self.pollFeed = self.polls
                self.tableView.reloadData()
                
            } else {
                println("Error loading data from parse: \(error)")
            }
        }
        
        ParseHelper.timelineRequestForCurrentUser { (result, error) -> Void in
            if error == nil {
                self.myPolls = result as? [Poll] ?? []
                 //println(self.myPolls)
            } else {
                println("Error loading data (myPoll) from parse: \(error)")
            }
        }
        
        
        ParseHelper.timelineRequestForVotedPolls { (result, error) -> Void in
            if error == nil {
                let relations = result as? [PFObject] ?? []
                
                self.votedPolls = relations.map {
                    $0.objectForKey("toPoll") as! Poll
                }
                
            } else {
                println("Error loading data(votedPolls) from parse: \(error)")
            }
        }

        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showExistingPoll" {
            let voteViewController = segue.destinationViewController as! VoteViewController
            voteViewController.voted4Delegate = self
            voteViewController.polls = poll
           
        }
        
        if segue.identifier == "createNewPoll"{
            let createViewController = segue.destinationViewController as! CreatePollViewController
            createViewController.addPollDelegate = self
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

extension MyPollsViewController:pollDelegate,votedForDelegate{
    
    func addPollItem(newPoll:Poll) {
        pollFeed.insert(newPoll, atIndex: 0)
        myPolls.insert(newPoll, atIndex: 0)
    }
    
    func addVotedForItem(newPoll: Poll) {
        votedPolls.insert(newPoll, atIndex: 0)
    }

}

