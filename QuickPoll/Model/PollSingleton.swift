//
//  PollSingleton.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/27/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation

class PollSingleton:NSObject {
    
    
    static let sharedInstance = PollSingleton()
    var poll:Poll = Poll()
    
    
    
}