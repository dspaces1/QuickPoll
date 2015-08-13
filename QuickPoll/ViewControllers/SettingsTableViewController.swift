//
//  SettingsTableViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 8/12/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SettingsTableViewController: UITableViewController {

    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    var emailComposer:email?
    var parseLoginHelper: ParseLoginHelper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = PFUser.currentUser()?.username
        emailLabel.text = PFUser.currentUser()?.email
    }

    
    
    func createLogoLabel() -> UILabel {
        var logInLogoTitle = UILabel()
        logInLogoTitle.text = "Quick Poll"
        logInLogoTitle.font = UIFont (name: "HelveticaNeue", size: 45)
        logInLogoTitle.textColor = UIColor.whiteColor()
        return logInLogoTitle
    }

    func logout () {
        
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                println("Error with login: \(error)")
            } else  if let user = user {
                // if login was successful, display the TabBarController
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UIViewController
                
                self.dismissViewControllerAnimated(true, completion: nil)
                self.presentViewController(tabBarController, animated:false, completion:nil)
            }
        }
        
        
        
        
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if let error = error {
                ErrorHandling.showAlertWithString("Error", messageText: "Could not log out. Please restart app", currentViewController: self)
            } else {
                
                let loginViewController = PFLogInViewController()
                loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
                
                let signIn_signUpBackgroundColor = UIColor(red: 80/255.0, green: 227/255.0, blue: 194/255.0, alpha: 1)
                
                loginViewController.logInView?.logo = self.createLogoLabel()
                
                loginViewController.logInView?.backgroundColor = signIn_signUpBackgroundColor
                
                loginViewController.signUpController?.signUpView!.logo = self.createLogoLabel()
                loginViewController.signUpController?.signUpView!.backgroundColor = signIn_signUpBackgroundColor
                
                loginViewController.delegate = self.parseLoginHelper
                loginViewController.signUpController?.delegate = self.parseLoginHelper
                
                self.presentViewController(loginViewController, animated: true, completion: nil)
 
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
