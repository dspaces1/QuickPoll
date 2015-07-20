//
//  KeyboardHandling.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import UIKit

class KeboardHandling: NSObject {
  
  let view: UIView!
  
  init (view: UIView!){
    self.view = view
    super.init()
    let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
    view.addGestureRecognizer(tap)
    
  }
  
  func DismissKeyboard(){
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
  
  
  
}