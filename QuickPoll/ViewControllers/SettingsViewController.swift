//
//  SettingsViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/9/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    // MARK: - Section: Class Properties
    
 
    @IBAction func signOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if let error = error {
                println("error: \(error)")
            } else {
                println("User Loged out")
                
                var appDel:AppDelegate = AppDelegate()
                appDel.logInScreen()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        println("Woot")
                    })
                })
            }
        }
        
    }

    // MARK: - Section: Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
