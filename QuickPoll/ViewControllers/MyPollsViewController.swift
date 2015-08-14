//
//  MyPollsViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class MyPollsViewController: UIViewController {
    
    // MARK: - Section: Class Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    var polls: [Poll] = [] {
        didSet {
            tableView.reloadData()
            refreshController.endRefreshing()
        }
    }

     struct pollArrays {
        var polls: [Poll] = []
        var loadedData:Bool = false
        var latestPollDate:NSDate = NSDate()
    }
    
    
    var pollFeed = pollArrays()
    var myPolls = pollArrays()
    var votedPolls = pollArrays()
    
    var feedArray:[pollArrays]!
    
    var delegate: pollDelegate?
    var poll:Poll?
    
    var refreshController:UIRefreshControl!


    // MARK: - Section: Class Methods
    
    @IBAction func changeFeedSource(sender: UISegmentedControl) {
        
        updateFeedData(sender.selectedSegmentIndex)
    }
    
    /// Updates feed data depending on what section is becomes selected
    func updateFeedData (segmentIndex:Int) {
        
        switch segmentIndex {
            
        case 0:
            polls = pollFeed.polls
            
        case 1:
            polls = myPolls.polls
            
        case 2:
            polls = votedPolls.polls
            
        default:
            ErrorHandling.showAlertWithString("Error", messageText: "Failed to load feed. Please try restarting app.", currentViewController: self)
        }
    }

    func setUpTableRefreshing () {
        
        refreshController = UIRefreshControl()
        refreshController.attributedTitle = NSAttributedString(string: "")
        refreshController.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshController)
    }
    
    
    func getPollFeed(){
        
        TimelineFeed.fetchPollFeed(pollFeed, date: pollFeed.latestPollDate) { (success, pollStruct) -> Void in
            
            if success {
                self.pollFeed = pollStruct
                
                for polls in self.pollFeed.polls {
                    polls.votedFor = false
                }
                
                self.updateFeedData(self.segmentView.selectedSegmentIndex)
            } else {
                ErrorHandling.showAlertWithString("Error", messageText: "Failed to load data from the server. Please try refreshing page.", currentViewController: self)
            }
            
            TimelineFeed.reEnableUI(self)
        }
    }
    
    func getMyPollFeed() {
        
        TimelineFeed.fetchMyPolls(myPolls, date: myPolls.latestPollDate) { (success, pollStruct) -> Void in
            
            if success {
                
                self.myPolls = pollStruct
   
                self.updateFeedData(self.segmentView.selectedSegmentIndex)
            } else {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                ErrorHandling.showAlertWithString("Error", messageText: "Failed to load data from the server. Please try refreshing page.", currentViewController: self)
            }
        }
    }
    
    func getVotedFeed () {
        
        TimelineFeed.fetchVotedForPolls(votedPolls, date: votedPolls.latestPollDate) { (success, pollStruct) -> Void in
            
            if success {
                self.votedPolls = pollStruct
                
                for polls in self.votedPolls.polls {
                    polls.votedFor = true
                }
                
                self.updateFeedData(self.segmentView.selectedSegmentIndex)
            } else {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                ErrorHandling.showAlertWithString("Error", messageText: "Failed to load data from the server. Please try refreshing page.", currentViewController: self)
            }
        }
    }
    
    
    func fetchPollsAccordingToSegment (currentSegment:Int){
        
        switch currentSegment {
            
        case 0:
            getPollFeed()
            
        case 1:
            getMyPollFeed()
            
        case 2:
            getVotedFeed()
            
        default:
            ErrorHandling.showAlertWithString("Error", messageText: "Please try restarting app", currentViewController: self)
            
        }

    }
    
    
    func refresh() {
        
        switch segmentView.selectedSegmentIndex {
            
        case 0:
            pollFeed = pollArrays()
            
        case 1:
            myPolls = pollArrays()
            
        case 2:
            votedPolls = pollArrays()
            
        default:
            ErrorHandling.showAlertWithString("Error", messageText: "Please try restarting app", currentViewController: self)
        }
        
        fetchPollsAccordingToSegment(segmentView.selectedSegmentIndex)
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
        
        feedArray = [pollFeed,myPolls,votedPolls]
        
        setUpTableRefreshing()
        
        TimelineFeed.startLoadAnimationAndDisableUI(self)

        
        getPollFeed()
        getMyPollFeed()
        getVotedFeed()
        updateFeedData(segmentView.selectedSegmentIndex)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tabBarController?.delegate = self
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showExistingPoll" {
            let voteViewController = segue.destinationViewController as! VoteViewController
            voteViewController.voted4Delegate = self
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
        cell.username.text = "By: \(polls[indexPath.row].user!.username!) "
        cell.categoryImage.image = UIImage(named:Poll.getCategoryImageString(polls[indexPath.row].category))
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        checkMarkVotedPolls(indexPath, cell: cell)
        
        cell.tintColor = UIColor(red: 82/255.0, green: 193/255.0, blue: 159/255.0, alpha: 0.80)

        return cell
    }
    
    ///Checks if poll was voted for and check marks it accordingly. Will fetch voted for relationship from parse if it does not exist locally
    func checkMarkVotedPolls(indexPath: NSIndexPath, cell:MyPollsTableViewCell) {
        
        if let pollChecked = polls[indexPath.row].votedFor{
            
            if pollChecked {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
        } else {
            polls[indexPath.row].fetchVotedPolls({ (success, error) -> Void in
                if success {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
            })
        }
    }
    
    
}


// MARK: UITableViewDataDelegate

extension MyPollsViewController:UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if (indexPath.row == (tableView.numberOfRowsInSection(0) - 1)) && !feedArray[segmentView.selectedSegmentIndex].loadedData {
            
            fetchPollsAccordingToSegment(segmentView.selectedSegmentIndex)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        poll = polls[indexPath.row]
        self.performSegueWithIdentifier("showExistingPoll", sender: self)
    }
    
}

extension MyPollsViewController:UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if viewController is PollFeedViewController {
            
            let createPollController:CreatePollViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Create Poll") as! CreatePollViewController
            createPollController.addPollDelegate = self
            self.presentViewController(createPollController, animated: true, completion: nil)

            return false
            
        } else{
            
            return true
        }
    }
}


// MARK: pollDelegate and votedForDelegate

extension MyPollsViewController:pollDelegate,votedForDelegate{
    
    func addPollItem(newPoll:Poll) {
    
        pollFeed.polls.insert(newPoll, atIndex: 0)
        myPolls.polls.insert(newPoll, atIndex: 0)
    }
    
    func addVotedForItem(newPoll: Poll) {
        votedPolls.polls.insert(newPoll, atIndex: 0)
        
        if newPoll.votedFor! {
            pollFeed.polls = pollFeed.polls.filter({$0 != newPoll})
        }
    }

}


