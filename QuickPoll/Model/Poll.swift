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
  //MARK: Variables
  //
  @NSManaged var user: PFUser?
  @NSManaged var title:String?
  @NSManaged var descriptionOfPoll:String?
  @NSManaged var category:Int
  @NSManaged var options:[NSDictionary]
  
  var option:NSDictionary = Dictionary<String,Int>()
  
  enum categoryType: Int{
    case entertainment = 0
    case news          = 1
    case edu           = 2
    case funny         = 3
    case health        = 4
  }
  
  //
  

  //MARK: functions
  //
  static func getCategoryImageString (categoryNumber:Int) ->String {
    var imageName:String
    
    switch categoryNumber {
    case 0:
      imageName = "Entertainment"
    case 1:
      imageName = "News"
    case 2:
      imageName = "Edu"
    case 3:
      imageName = "Funny"
    case 4:
      imageName = "Health"
    default:
      imageName = "Health"
    }
    return imageName
    
  }
  
  func postPoll(#pollTitle:String, pollDescribtion:String, arrayWithOptions:[NSDictionary], categoryTypeIndex:Int) {
    
    user = PFUser.currentUser()
    self.options = arrayWithOptions
    self.title = pollTitle
    self.descriptionOfPoll = pollDescribtion
    self.category = categoryTypeIndex
    
    saveInBackgroundWithBlock { (success, error) -> Void in
      if success {
        println("saved to parse server")
      } else {
        println(error)
      }
      
    }
  }
  
  
  func fetchTitle(){
    
  }
  
  func fetchCategory(){
    
  }
  
  //
  
  
  
  //MARK: PFSublassing Protocol
  //
  
  override init() {
    super.init()
  }
  
  static func parseClassName() -> String{
    return "Poll"
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