//
//  VoteViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/6/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse

protocol votedForDelegate:NSObjectProtocol {
    func addVotedForItem (newPoll:Poll)
}

class VoteViewController: UIViewController {
  
    // MARK: - Section: Class Properties
    
    @IBOutlet weak var titleOfPoll: UILabel!
    @IBOutlet weak var descriptionOfPoll: UITextView!
    @IBOutlet weak var tableViewWithOptions: UITableView!
    
    @IBOutlet weak var vote_doneButton: UIButton!
    
    var selectionOption:Int?
    var polls: Poll?
    weak var voted4Delegate:votedForDelegate?
    var animateFlag:Bool = false
    
    var totalVotes:Int = 0
    var voteCount:Int = 0
    var emailComposer:email?
    
    // MARK: - Section: Class Methods
    
    
    @IBAction func reportPoll(sender: AnyObject) {
        
        emailComposer = email(currentController: self, pollTitleAndUser: ["\(polls!.title!)" , "\(polls!.user!.username!)"])

    
    }
    
    
    @IBAction func voteForPoll(sender: AnyObject) {
        
        if let votedFor = polls?.votedFor{
            if votedFor {
                self.navigationController!.popToRootViewControllerAnimated(true)
            } else {
                sendVoteRequestToParse()
            }
        } else {
            sendVoteRequestToParse()
        }
        
    }
    
    /// Send voted for option to parse.
    func sendVoteRequestToParse () {
        if let selectionOption = selectionOption {

            polls?.options[selectionOption]["votes"] = polls?.options[selectionOption]["votes"] as! Int + 1
            
            totalVotes++
            
            TimelineFeed.startLoadAnimationAndDisableUI(self)
            
            ParseHelper.voteForPoll(PFUser.currentUser()!, poll:polls!){ (success, error) -> Void in
                
                if let error = error {
                    ErrorHandling.showAlertWithString("Error", messageText: "Could not send vote to server. Please try again.", currentViewController: self)
                  
                } else {
                    //ErrorHandling.showAlertWithString("Success", messageText: "Submitted Vote.", currentViewController: self)
                    self.polls?.votedFor = true
                    self.voted4Delegate?.addVotedForItem(self.polls!)
         
                }
                TimelineFeed.reEnableUI(self)
                
            }
            animateBarResults()
        }
    }
    
    
    /// Animate voting results bar based on vote count
    func animateBarResults () {
        
        vote_doneButton.setTitle("Done", forState: UIControlState.Normal)
        animateFlag = true
        
        if totalVotes == 0 { totalVotes = 1}
        
        for cell in tableViewWithOptions.visibleCells(){
            
            let cellIndex:NSIndexPath = tableViewWithOptions.indexPathForCell(cell as! UITableViewCell)!
            let currentCell = tableViewWithOptions.cellForRowAtIndexPath(cellIndex) as! VoteOptionTableViewCell

            voteCount = polls?.options[cellIndex.row]["votes"] as! Int
            
            currentCell.selectOption.hidden = true
            
            
            let maxResultBarWidth = currentCell.getBarMaxWidth()
            var percentageOfVotes:Float = 0
            var voteCountAsString:String = "0"
            var newResultBarWidth:CGFloat = 0
            
            if voteCount > 0 {
                percentageOfVotes = Float(self.voteCount) / Float(self.totalVotes)
                voteCountAsString = "\(String(self.voteCount))"
                newResultBarWidth = CGFloat(percentageOfVotes) * maxResultBarWidth
            }
            
            UIView.animateWithDuration(0.75, animations: { () -> Void in

                currentCell.alignYConstraintOfDescription.constant -= 17
                currentCell.alignXConstraintOfDescription.constant -= 12 + currentCell.buttonWidth.constant
                
                currentCell.voteCount.hidden = false
                currentCell.voteCount.text! = voteCountAsString
                currentCell.optionDescription.text! += " (\(Int(percentageOfVotes * 100))%)"
                currentCell.barWidth.constant =  newResultBarWidth
                
                currentCell.layoutIfNeeded()
                
            })
            
            
        }
        
    }
    
    /// Create a new Back Button
    func createNewBackButton () {
            
        navigationController!.setNavigationBarHidden(false, animated:true)
            
        var myBackButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        myBackButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.setTitle("Back", forState: UIControlState.Normal)
        myBackButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myBackButton.sizeToFit()
            
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
        
    /// Send back button to main view
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let votedFor = polls?.votedFor{
            if votedFor && !animateFlag {animateBarResults()}
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleOfPoll.text = polls?.title
        descriptionOfPoll.text = polls?.descriptionOfPoll
        descriptionOfPoll.textAlignment = .Center
        createNewBackButton()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// MARK: - Protocols
// MARK: UITableViewDataSource
extension VoteViewController:UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return polls!.options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("optionCell") as! VoteOptionTableViewCell
        
        cell.optionDescription.text = polls!.options[indexPath.row]["name"] as? String
        cell.resultsBarImage.image = UIImage(named: cell.imageArray[indexPath.row])
        
        voteCount = polls?.options[indexPath.row]["votes"] as! Int
        
        totalVotes += voteCount
 
        cell.voteCount.hidden = true
        
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension VoteViewController:UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){

        selectionOption = indexPath.row
        
        for cell in tableView.visibleCells() {
      
            let cellIndex:NSIndexPath = tableView.indexPathForCell(cell as! UITableViewCell)!
            let currentCell = tableView.cellForRowAtIndexPath(cellIndex) as! VoteOptionTableViewCell
      
            tableView.deselectRowAtIndexPath(cellIndex, animated: true)
      
            if cellIndex.row != indexPath.row {
                currentCell.selectOption.selected = false
            }else {
                currentCell.selectOption.selected = true
            }
        }
    }
  
}





