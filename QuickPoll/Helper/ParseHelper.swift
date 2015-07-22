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
    
    static func votedForRequestForCurrentUser (user:PFUser, poll:Poll,completionBlock:PFArrayResultBlock){
        let pollsVotedFromThisUser = PFQuery(className: "Voted")
        pollsVotedFromThisUser.whereKey("fromUser", equalTo: user)
        pollsVotedFromThisUser.whereKey("toPoll", equalTo: poll)
        pollsVotedFromThisUser.includeKey("fromUser")
        
        pollsVotedFromThisUser.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func voteForPoll (user:PFUser, poll:Poll) {
        let vote = PFObject(className: "Voted")
        vote["fromUser"] = user
        vote["toPoll"] = poll
        vote.saveInBackgroundWithBlock(nil)
    }
  
}