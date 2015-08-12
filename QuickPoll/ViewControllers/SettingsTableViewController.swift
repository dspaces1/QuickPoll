//
//  SettingsTableViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 8/12/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse

class SettingsTableViewController: UITableViewController {

    var emailComposer:email?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }



    func logout () {
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
    
    func createEmail() {
        emailComposer = email(currentController: self, user: PFUser.currentUser()!.username!)
    }

}

extension SettingsTableViewController:UITableViewDelegate {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if let identifier =  cell.reuseIdentifier{
            if identifier == "logout" {
                logout()
            }
            if identifier == "Report Problem" {
                createEmail()
            }
        }
    }
    
}
