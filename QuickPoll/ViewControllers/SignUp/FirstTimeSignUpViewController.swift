//
//  FirstTimeSignUpViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/13/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FirstTimeSignUpViewController: UIViewController {

  // MARK: Outlets
  //
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var emailField: UITextField!

  
  //
  
  // MARK: functions
  //

  @IBAction func facebookSignIn(sender: AnyObject) {
    
    FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result, error) -> Void in
      
      if let error = error{
        println("Facebook error: \(error)")
      }
      
      if let facebookUserName = result?["Name"] as? String {
        
      }
      
    }
  }
  
  //
  
  //Mark: var
  //
    var keboardHandler:KeboardHandling!
  //
  
  
  // MARK: Set Up
  //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    usernameField.delegate = self
    keboardHandler = KeboardHandling(view: view!)
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
      let newUser:UserSettings = UserSettings()
     
      if !newUser.signUp(){
        println("failed to sign up")
      }
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


