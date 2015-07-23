//
//  VoteViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/6/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse

class VoteViewController: UIViewController {
  
    // MARK: - Section: Class Properties
    
    @IBOutlet weak var titleOfPoll: UILabel!
    @IBOutlet weak var descriptionOfPoll: UITextView!
    @IBOutlet weak var tableViewWithOptions: UITableView!
    
    var selectionOption:Int?
    var polls: Poll?
    
    // MARK: - Section: Class Methods
    
    @IBAction func voteForPoll(sender: AnyObject) {
        
        if let selectionOption = selectionOption {
            
            polls?.options[selectionOption]["votes"] = polls?.options[selectionOption]["votes"] as! Int + 1
            
            ParseHelper.voteForPoll(PFUser.currentUser()!, poll:polls!){ (success, error) -> Void in
                
                if let error = error {
                    println("error pushing vote to parse \(error)")
                } else {
                    println("success")
                }
                
            }
            
            animateBarResults()
            
            //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            //Begin animation effects
            
        }
    }
    
    ///Animate voting results bar based on vote count
    func animateBarResults () {
        for cell in tableViewWithOptions.visibleCells(){
            
            let cellIndex:NSIndexPath = tableViewWithOptions.indexPathForCell(cell as! UITableViewCell)!
            let currentCell = tableViewWithOptions.cellForRowAtIndexPath(cellIndex) as! VoteOptionTableViewCell
            //currentCell.selectOption.selected = false
            let voteCount:Int = polls?.options[cellIndex.row]["votes"] as! Int
            
            let voteCountAsString:String = String(voteCount)
            currentCell.voteCount.text! = voteCountAsString
            currentCell.selectOption.hidden = true
            
           
            UIView.animateWithDuration(1, animations: { () -> Void in

                currentCell.alignYConstraintOfDescription.constant -= 17
                //currentCell.selectOption.alpha = 0
                currentCell.alignXConstraintOfBar.constant +=  CGFloat((voteCount * 100))
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        titleOfPoll.text = polls?.title
        descriptionOfPoll.text = polls?.descriptionOfPoll
        createNewBackButton()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //cell.resultsBar.hidden = true
        cell.alignXConstraintOfBar.constant -= cell.resultsBar.bounds.width
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




