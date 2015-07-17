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
  
  
  //MARK: Var
  //
  
  var userEmail:String = ""
  var password:String = ""
  var gender:String?
  var age:Int?
  //
  
  
  //Mark: functions
  //
  
  func signUp () -> Bool {
    
    var successfulSignUp:Bool = true
    
    var user = PFUser()
    user.username = "email@example.com"
    user.password = "myPassword"
    user.email = "email@example.com"
    // other fields can be set just like with PFObject
    user["age"] = 1
    user["gender"] = "male"
    
    
    user.signUpInBackgroundWithBlock {
      (succeeded: Bool, error: NSError?) -> Void in
      if let error = error {
        let errorString = error.userInfo?["error"] as? NSString
        println(errorString)
      } else {
        println("Sign in successful")
      }
    }
    
    return successfulSignUp
  }
  //

  //MARK: PFSublassing Protocol
  //
  
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
  //
  
}