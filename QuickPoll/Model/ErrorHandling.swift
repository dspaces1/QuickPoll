//
//  ErrorHandling.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import UIKit


class ErrorHandling {
  
  static let ErrorTitle           = "Error"
  static let ErrorOKButtonTitle   = "Ok"
  static let ErrorDefaultMessage  = "Something unexpected happened, sorry for that!"
  
  static func emptyStringOrNil (checkString:String?) ->Bool {
    
    if let string = checkString {
      
      let trimString = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      return trimString.isEmpty
    }
    return true
  }
  

  
}