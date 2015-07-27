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
  
    // MARK: - Section: Class Methods
    
    static func timelineRequestForCurrentUser (completionBlock:PFArrayResultBlock ) {
        let pollsFromThisUser = Poll.query()
        pollsFromThisUser?.whereKey("user", equalTo: PFUser.currentUser()!)
        pollsFromThisUser?.includeKey("user")
        pollsFromThisUser?.orderByDescending("createdAt")
        pollsFromThisUser?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func timelineRequestForAllPolls (completionBlock:PFArrayResultBlock ) {
        let pollsFromThisUser = Poll.query()
        pollsFromThisUser?.includeKey("user")
        pollsFromThisUser?.orderByDescending("createdAt")
        pollsFromThisUser?.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    
    //Get Polls
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