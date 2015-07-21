//
//  UserSettings.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/9/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import Parse


class UserSettings: PFObject, PFSubclassing {
    
    
    //MARK: - Section: Class Methods
    
    static func parseClassName() -> String{
        return "User"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
    
}