//
//  MyPollsViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit

class MyPollsViewController: UIViewController {
    
    // MARK: - Section: Class Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    var polls: [Poll] = [] {
        didSet { tableView.reloadData() }
    }
    
    var pollFeed: [Poll] = []
    var myPolls: [Poll] = []
    var votedPolls: [Poll] = []
    
    var delegate: pollDelegate?
    var poll:Poll?
    
    var refreshController:UIRefreshControl!
    
    var loadedAllData = false
    var latestPollDate:NSDate = NSDate()

    // MARK: - Section: Class Methods
    
    @IBAction func changeFeedSource(sender: UISegmentedControl) {
        
        updateFeedData(sender.selectedSegmentIndex)
    }
    
    /// Updates feed data depending on what section is becomes selected
    func updateFeedData (segmentIndex:Int) {
        
        switch segmentIndex {
            
        case 0:
            polls = pollFeed
            
        case 1:
            polls = myPolls
            
        case 2:
            polls = votedPolls
            
        default:
            ErrorHandling.showAlertWithString("Error", messageText: "Failed to load feed. Please try restarting app.", currentViewController: self)
        }
    }
    
    
    /// Fetch all Poll Data From Parse
    func fetchAllPollsAndRefresh(date:NSDate) {
    
        ParseHelper.timelineRequestForAllPolls(date) { (resultFromAllPolls, error) -> Void in
            if error == nil {

                
                ParseHelper.timelineRequestForVotedPolls { (result, error) -> Void in
                    if error == nil {

                        if resultFromAllPolls!.isEmpty {
                            self.loadedAllData = true
                            println("Looaded all data")
                        }
                        
                        self.polls += resultFromAllPolls as? [Poll] ?? [] //Set +=
                        let relations = result as? [PFObject] ?? []
                        
                        self.votedPolls = relations.map {
                            $0.objectForKey("toPoll") as! Poll
                        }
                        
                        self.latestPollDate = self.polls[self.polls.count - 1].createdAt!
                        
                        self.setMyPolls()
                        
                        self.updateFeedData(self.segmentView.selectedSegmentIndex)
                        
                        self.refreshController.endRefreshing()
                        

                    } else {
                        
                        ErrorHandling.showAlertWithString("Error", messageText: "Failed to load data from server.", currentViewController: self)
                    }
                }
                
            } else {
                ErrorHandling.showAlertWithString("Error", messageText: "Failed to load data from server.", currentViewController: self)
            }
        }

    }
    
    
    
    
    
    
    /// Filter poll array to get all polls created by the current user. Also, sets voted for flags on all polls user voted for.
    func setMyPolls () {
        
        let allPollsNotVotedFor = self.polls.filter{(!contains(self.votedPolls,$0))}
        
        myPolls =   polls.filter({ poll in poll.user == PFUser.currentUser() })
        polls = polls.map({ (poll) -> Poll in
            poll.votedFor = !contains(allPollsNotVotedFor, poll)
            return poll
        })

        
        self.pollFeed = allPollsNotVotedFor
    }

    func setUpTableRefreshing () {
        
        refreshController = UIRefreshControl()
        refreshController.attributedTitle = NSAttributedString(string: "")
        refreshController.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshController)
    }
    
    func refresh() {
        polls = []
        fetchAllPollsAndRefresh(NSDate())
        loadedAllData = false 
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        updateFeedData(segmentView.selectedSegmentIndex)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllPollsAndRefresh(NSDate())
   
        setUpTableRefreshing()
     
        
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
        else if segue.identifier == "createNewPoll"{
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
        
        // add poll property on MyPollsTableViewCell to turn this into
        // cell.poll = polls[indexPath.row]
        cell.title.text = polls[indexPath.row].title
        cell.username.text = "By: \(polls[indexPath.row].user!.username!) " //Can user be nil at this point?
        cell.categoryImage.image = UIImage(named:Poll.getCategoryImageString(polls[indexPath.row].category))
        
        checkMarkVotedPolls(indexPath, cell: cell)
        
        cell.tintColor = UIColor(red: 82/255.0, green: 193/255.0, blue: 159/255.0, alpha: 0.80)

        return cell
    }
    
    ///Checks if poll was voted for and check marks it accordingly. Will fetch voted for relationship from parse if it does not exist locally
    func checkMarkVotedPolls(indexPath: NSIndexPath, cell:MyPollsTableViewCell) {
        
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
    }
    
    
}

// MARK: UITableViewDataDelegate

extension MyPollsViewController:UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if (indexPath.row == (tableView.numberOfRowsInSection(0) - 1)) && !loadedAllData {
            
            fetchAllPollsAndRefresh(latestPollDate)
           
            println("fetching")
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        poll = polls[indexPath.row]
        self.performSegueWithIdentifier("showExistingPoll", sender: self)
    }
    
}

// MARK: pollDelegate and votedForDelegate

extension MyPollsViewController:pollDelegate,votedForDelegate{
    
    func addPollItem(newPoll:Poll) {
    
        pollFeed.insert(newPoll, atIndex: 0)
        myPolls.insert(newPoll, atIndex: 0)
    }
    
    func addVotedForItem(newPoll: Poll) {
        votedPolls.insert(newPoll, atIndex: 0)
        
        if newPoll.votedFor! {
            pollFeed = pollFeed.filter({$0 != newPoll})
        }
    }

}

