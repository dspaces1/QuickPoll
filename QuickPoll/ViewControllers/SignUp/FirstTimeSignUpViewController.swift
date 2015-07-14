//
//  FirstTimeSignUpViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/13/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class FirstTimeSignUpViewController: UIViewController {

  // MARK: Outlets
  //
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var ageField: UITextField!
  
  //
  
  // MARK: functions
  //
  
  func DismissKeyboard(){
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
  
  //
  
  
  // MARK: Set Up
  //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    usernameField.delegate = self
    
      
    let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
    view.addGestureRecognizer(tap)
  }

  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  
  //
  
  
  
  // MARK: - Navigation
  //
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "SignedUp" {
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "SignedIn")
    }
  }
  
  //

}



extension FirstTimeSignUpViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}


