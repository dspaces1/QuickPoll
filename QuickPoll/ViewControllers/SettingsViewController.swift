//
//  SettingsViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/9/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  //Mark: IB actions
  //
  
  @IBAction func resetSignUp(sender: AnyObject) {
    NSUserDefaults.standardUserDefaults().setBool(false, forKey: "SignedIn")
    
  }
  
  //
  
  
  
  //Mark: Setup
  //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  //

}
