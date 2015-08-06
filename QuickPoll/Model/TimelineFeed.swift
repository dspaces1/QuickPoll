//
//  TimelineFeed.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 8/5/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import Parse

typealias PollFetchResultBlock = (Bool, MyPollsViewController.pollArrays) -> Void

class TimelineFeed:NSObject {
    

    
    static func fetchVotedForPolls (var currentPolls: MyPollsViewController.pollArrays ,date:NSDate, completionBlock: PollFetchResultBlock) {
        
        ParseHelper.timelineRequestForAllPolls(date, completionBlock: { (resultsFromAllPolls, error) -> Void in
            
            if error == nil {
                
                ParseHelper.timelineRequestForVotedPolls({ (result, error) -> Void in
                    
                    if error == nil {
                        if resultsFromAllPolls!.isEmpty {
                            currentPolls.loadedData = true
                            return
                        }
                        
                        let newPollResults = resultsFromAllPolls as? [Poll] ?? []
                        let relations = result as? [PFObject] ?? []
                        
                        var votedForPollsFilter = relations.map{
                            $0.objectForKey("toPoll") as! Poll
                        }
                        
                        let allPollsVotedFor = newPollResults.filter({contains(votedForPollsFilter,$0)})
                        
                        currentPolls.polls += allPollsVotedFor
                        
                        currentPolls.latestPollDate = newPollResults[newPollResults.count - 1].createdAt!
                        
                        completionBlock(true,currentPolls)
                        
                    } else {
                        completionBlock(false,currentPolls)
                    }
                })
                
            } else {
                completionBlock(false,currentPolls)
            }
        })
        
        
    }

    
    
    
    // Fetch poll feed
    
    static func fetchPollFeed (var currentPolls: MyPollsViewController.pollArrays ,date:NSDate, completionBlock: PollFetchResultBlock) {
        
        ParseHelper.timelineRequestForAllPolls(date, completionBlock: { (resultsFromAllPolls, error) -> Void in
            
            if error == nil {
                
                ParseHelper.timelineRequestForVotedPolls({ (result, error) -> Void in
                    
                    if error == nil {
                        //println(resultsFromAllPolls)
                        if resultsFromAllPolls!.isEmpty {
                            currentPolls.loadedData = true
                            return 
                        }
                        
                        let newPollResults = resultsFromAllPolls as? [Poll] ?? []
                        let relations = result as? [PFObject] ?? []
                        
                        var votedForPollsFilter = relations.map{
                            $0.objectForKey("toPoll") as! Poll
                        }
                        
                        let allPollsNotVotedFor = newPollResults.filter({!contains(votedForPollsFilter,$0)})
                        
                        currentPolls.polls += allPollsNotVotedFor
                    
                        currentPolls.latestPollDate = newPollResults[newPollResults.count - 1].createdAt!
      
                        completionBlock(true,currentPolls)
                        
                    } else {
                        completionBlock(false,currentPolls)
                    }
                })
                
            } else {
                completionBlock(false,currentPolls)
            }
        })
        
        
    }
    
    
    // fetch my polls
    static func fetchMyPolls (var currentPolls: MyPollsViewController.pollArrays ,date:NSDate, completionBlock: PollFetchResultBlock) {
        
        ParseHelper.timelineRequestForCurrentUser(date, completionBlock: { (resultsFromMyPolls, error) -> Void in
            
            if error == nil {
                
                ParseHelper.timelineRequestForVotedPolls({ (result, error) -> Void in
                    
                    if error == nil {
                        
                        if resultsFromMyPolls!.isEmpty {
                            currentPolls.loadedData = true
                            return
                        }
                        
                        var newPollResults = resultsFromMyPolls as? [Poll] ?? []
                        let relations = result as? [PFObject] ?? []
                        
                        var votedForPollsFilter = relations.map{
                            $0.objectForKey("toPoll") as! Poll
                        }
                        
                        let allPollsNotVotedFor = newPollResults.filter{(!contains(votedForPollsFilter,$0))}
                        
                        newPollResults = newPollResults.map({ (poll) -> Poll in
                            poll.votedFor = !contains(allPollsNotVotedFor, poll)
                            return poll
                        })
                        
                        currentPolls.polls += newPollResults
                        
                        currentPolls.latestPollDate = newPollResults[newPollResults.count - 1].createdAt!
  
                        completionBlock(true,currentPolls)
                        
                    } else {
                        completionBlock(false,currentPolls)
                    }
                })
                
            } else {
                completionBlock(false,currentPolls)
            }
        })
        
    }
    
    
    
    
}