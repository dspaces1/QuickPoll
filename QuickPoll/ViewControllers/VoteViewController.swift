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
    var polls: Poll?
    
    // MARK: - Section: Class Methods
    
    @IBAction func voteForPoll(sender: AnyObject) {
        ParseHelper.voteForPoll(PFUser.currentUser()!, poll:polls! )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        titleOfPoll.text = polls?.title
        descriptionOfPoll.text = polls?.descriptionOfPoll
        println(polls!.options)
        //titleOfPoll.text = pollTitle
        //descriptionOfPoll.text = pollDescription
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
        
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension VoteViewController:UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){

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




