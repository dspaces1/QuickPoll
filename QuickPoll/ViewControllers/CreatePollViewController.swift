//
//  CreatePollViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class CreatePollViewController: UIViewController {
    
    // MARK: - Section: Class Properties
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var categoryPicker: UISegmentedControl!
    @IBOutlet weak var titleOfPoll: UITextField!
    @IBOutlet weak var descriptionOfPoll: UITextView!
    var optionArr:[NSDictionary]? = [NSDictionary]()
    var keboardHandler:KeboardHandling!
    
    
    //MARK: - Section: Class Methods
    
    /// This button press method checks for valid fields and pushes poll data to parse
    @IBAction func createPoll(sender: AnyObject) {
        
        if ErrorHandling.emptyStringOrNil(titleOfPoll.text) {
            println("nil or empty title")
            return
        }
        if ErrorHandling.emptyStringOrNil(descriptionOfPoll.text) {
            println("nil or empty description")
            return
        }
        
        let myPoll = Poll()
        
        if let optionArr = createOptionArray(myPoll) {
            
            myPoll.postPoll(pollTitle: titleOfPoll.text, pollDescribtion: descriptionOfPoll.text, arrayWithOptions: optionArr, categoryTypeIndex: categoryPicker.selectedSegmentIndex)  //Post to Parse
        } else {
            println("nil values found in cells ")
            return
        }
        
        
    }
    
    /**
    Grabs option description from visible cells.
    
    :param: myPoll Parse subclass with Dictionary format.
    :returns: all poll options with 0 votes each, nil if empyty cell describtions.
    */
    func createOptionArray (myPoll:Poll) -> [NSDictionary]?{
        
        for cell in optionsTableView.visibleCells() {
            
            let cellContent:CreatePollTableViewCell = cell as! CreatePollTableViewCell
            let cellIndex:NSIndexPath = optionsTableView.indexPathForCell(cellContent)!
            
            if let cellTextFieldString = cellContent.optionDescription?.text {
                
                let isEmpty:Bool = ErrorHandling.emptyStringOrNil(cellTextFieldString)
                
                if cellIndex.row <= 1 && isEmpty  {
                    println("nil cell at cellindex: \(cellIndex.row)")
                    return nil
                }
                if !isEmpty {
                    myPoll.option = [ "name" : cellTextFieldString , "votes" : 0 ]
                    optionArr!.append(myPoll.option)
                }
            }
        }
        
        
        return optionArr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        titleOfPoll.delegate = self
        keboardHandler = KeboardHandling(view: view!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "createdPoll" {
            let viewController:VoteViewController = segue.destinationViewController as! VoteViewController
            viewController.option = optionArr!
            viewController.pollTitle = titleOfPoll.text
            viewController.pollDescription = descriptionOfPoll.text
        }
    }
    
}

// MARK: - Protocols
// MARK: UITextFieldDelegate

extension CreatePollViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

//MARK: UITableViewDataSource

extension CreatePollViewController:UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows:Int = 4
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("createOption") as! CreatePollTableViewCell
        return cell
    }
}


