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
    //var barMaxWidthForAnimation:CGFloat!
    var totalVotes:Int = 0
    var voteCount:Int = 0
    // MARK: - Section: Class Methods
    
    @IBAction func voteForPoll(sender: AnyObject) {
        
        if let votedFor = polls?.votedFor{
            if votedFor {
                self.navigationController!.popToRootViewControllerAnimated(true)
            } else {
                sendRequestToParse()
            }
        } else {
            sendRequestToParse()
        }
        
    }
    
    func sendRequestToParse () {
        if let selectionOption = selectionOption {
            
            
            
            polls?.options[selectionOption]["votes"] = polls?.options[selectionOption]["votes"] as! Int + 1
            
            totalVotes++
            
            ParseHelper.voteForPoll(PFUser.currentUser()!, poll:polls!){ (success, error) -> Void in
                
                if let error = error {
                    println("error pushing vote to parse \(error)")
                } else {
                    println("success")
                    self.polls?.votedFor = true
                    self.voted4Delegate?.addVotedForItem(self.polls!)
                }
                
            }
            animateBarResults()
        }
    }
    
    
    ///Animate voting results bar based on vote count
    func animateBarResults () {
        if totalVotes == 0 { totalVotes = 1}
        
        for cell in tableViewWithOptions.visibleCells(){
            
            let cellIndex:NSIndexPath = tableViewWithOptions.indexPathForCell(cell as! UITableViewCell)!
            let currentCell = tableViewWithOptions.cellForRowAtIndexPath(cellIndex) as! VoteOptionTableViewCell
            //currentCell.selectOption.selected = false
            voteCount = polls?.options[cellIndex.row]["votes"] as! Int
            
            
            currentCell.selectOption.hidden = true
            
            UIView.animateWithDuration(0.75, animations: { () -> Void in

                currentCell.alignYConstraintOfDescription.constant -= 17
                //currentCell.selectOption.alpha = 0
                
                let maxResultBarWidth = currentCell.getBarMaxWidth()
                
                
                if self.voteCount < 1 {
                    currentCell.barWidth.constant = 0
                }else {
                    let percentageOfVotes = Float(self.voteCount) / Float(self.totalVotes)
                    println("vote count: \(self.voteCount)\n total votes: \(self.totalVotes)")
                    println("Percentage of Votes: \(percentageOfVotes)")
                    
                    currentCell.voteCount.hidden = false
                    let voteCountAsString:String = "\(Int(percentageOfVotes * 100))% ( \( String(self.voteCount) ) )" //String(format: "%1.2f", arguments: [percentageOfVotes])
                    currentCell.voteCount.text! = voteCountAsString
                    
                    
                    let newResultBarWidth:CGFloat = CGFloat(percentageOfVotes) * maxResultBarWidth
                    println("New Result Bar Width: \(newResultBarWidth)")
                    
                    currentCell.barWidth.constant =  newResultBarWidth
                    println("Current cell bar width \(currentCell.barWidth.constant)")
                    
                }
                currentCell.layoutIfNeeded()
                
            })
            
            vote_doneButton.setTitle("Done", forState: UIControlState.Normal)
            animateFlag = true
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
        println(polls!.options)
        cell.optionDescription.text = polls!.options[indexPath.row]["name"] as? String
        cell.resultsBarImage.image = UIImage(named: cell.imageArray[indexPath.row])
        
        voteCount = polls?.options[indexPath.row]["votes"] as! Int
        
        totalVotes += voteCount
        
        //let voteCountAsString:String = String(voteCount)
        //cell.voteCount.text! = voteCountAsString
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




