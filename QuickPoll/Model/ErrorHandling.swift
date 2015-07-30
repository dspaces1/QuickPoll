//
//  ErrorHandling.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import UIKit


class ErrorHandling: NSObject {
    
    // MARK: - Section: Declared Types
    
    struct Constants {
        static let ErrorTitle           = "Error"
        static let ErrorOKButtonTitle   = "Ok"
        static let ErrorDefaultMessage  = "Something unexpected happened, sorry for that!"
    }
    
    // MARK: - Section: Class Methods
    
    
    func showAlertWithString(message:String) {
        UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "Cancel").show()
        
        
//        var alert = UIAlertController(title: "Alert", message: "Error", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
//        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /**
    Checks to see if a string is valid
    
    :param: checkString any string or nil
    :returns: true if the string is not emtpy or nil
    */
    static func emptyStringOrNil (checkString:String?) ->Bool {
        
        if let string = checkString {
            
            let trimString = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            return trimString.isEmpty
        }
        return true
    }
}