//
//  Poll.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/2/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import Parse


class Poll: PFObject, PFSubclassing {
  
  
  
  
  
  
  //MARK: PFSublassing Protocol
  static func parseClassName() -> String{
    return "Poll"
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