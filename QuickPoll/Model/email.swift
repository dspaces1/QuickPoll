//
//  email.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 8/6/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import MessageUI



//typealias EmailCallBack = Void -> Void

class email:NSObject {
    
    let emailTo:[String] = ["quickpollapp1@gmail.com"]
    let reportPoll:String = "Report Concern"
    var pollToReport:String!
    
    let mailController:MFMailComposeViewController = MFMailComposeViewController()
    weak var viewController: UIViewController!
    
    
    init(currentController:UIViewController, pollTitleAndUser:[String]){
        pollToReport = "I would like to report poll: \(pollTitleAndUser[0]) by: \(pollTitleAndUser[1]) for being inappropriate because "
        viewController = currentController
        
        super.init()

        displayMailComposer()
    }
    
    init(currentController:UIViewController, user:String){
        pollToReport = ""
        viewController = currentController
        
        super.init()
        
        displayMailComposer()
    }

    
    
    func displayMailComposer () {
        
        if MFMailComposeViewController.canSendMail() {
            
            mailController.mailComposeDelegate = self
            mailController.setToRecipients(emailTo)
            mailController.setSubject(reportPoll)
            mailController.setMessageBody(pollToReport, isHTML: false)
            
            viewController.presentViewController(mailController, animated: true, completion: nil)
            
        }else {
            ErrorHandling.showAlertWithString("Error", messageText: "Could not display email, please try again", currentViewController: viewController)
        }
    }
    
    
}

extension email:MFMailComposeViewControllerDelegate {
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
                
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
}