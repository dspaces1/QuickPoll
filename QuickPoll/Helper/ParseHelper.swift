//
//  ParseHelper.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/2/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    var user: PFUser!
    

    
  
    // MARK: - Section: Class Methods
    
    static func timelineRequestForCurrentUser (sinceDate:NSDate, completionBlock:PFArrayResultBlock ) {
        let pollsFromThisUser = Poll.query()
        pollsFromThisUser?.whereKey("user", equalTo: PFUser.currentUser()!)
        pollsFromThisUser?.includeKey("user")
        pollsFromThisUser?.whereKey("createdAt", lessThan: sinceDate)
        
        pollsFromThisUser?.limit = 20
        
        pollsFromThisUser?.orderByDescending("createdAt")
        pollsFromThisUser?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    /// Get all polls
    static func timelineRequestForAllPolls (sinceDate:NSDate, completionBlock:PFArrayResultBlock ) {
        
        let allPollsQuery = Poll.query()
        allPollsQuery?.includeKey("user")
        allPollsQuery?.whereKey("createdAt", lessThan: sinceDate)
        
        allPollsQuery?.limit = 20
        
        allPollsQuery?.orderByDescending("createdAt")
        allPollsQuery?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    /// Get Voted Polls
    static func timelineRequestForVotedPolls (completionBlock:PFArrayResultBlock ) {
        let pollsVotedFromThisUser = PFQuery(className: "Voted")
        pollsVotedFromThisUser.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        pollsVotedFromThisUser.includeKey("toPoll")
        
        pollsVotedFromThisUser.findObjectsInBackgroundWithBlock(completionBlock)
        

    }
    
    
    static func votedForRequestForCurrentUser (poll:Poll,completionBlock:PFArrayResultBlock){
        let pollsVotedFromThisUser = PFQuery(className: "Voted")
        pollsVotedFromThisUser.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        pollsVotedFromThisUser.whereKey("toPoll", equalTo: poll)
        
        pollsVotedFromThisUser.findObjectsInBackgroundWithBlock(completionBlock)
    }
    

    
    
    
    static func voteForPoll (user:PFUser, poll:Poll,completionBlock:PFBooleanResultBlock) {
        let vote = PFObject(className: "Voted")
        vote["fromUser"] = user
        vote["toPoll"] = poll
        vote.saveInBackgroundWithBlock(completionBlock)
    }
  
}