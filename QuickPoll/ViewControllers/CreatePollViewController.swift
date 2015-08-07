//
//  CreatePollViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

protocol pollDelegate:NSObjectProtocol {
    func addPollItem(newPoll:Poll)
}

class CreatePollViewController: UIViewController {
    
    // MARK: - Section: Class Properties
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var categoryPicker: UISegmentedControl!
    @IBOutlet weak var titleOfPoll: UITextField!
    @IBOutlet weak var descriptionOfPoll: UITextView!
    
    var optionArr:[Dictionary<String,AnyObject>]? = [Dictionary<String,AnyObject>]()
    var keboardHandler:KeboardHandling!
    var isPlaceHolderText:Bool = true
    var myPoll:Poll?
    
    weak var addPollDelegate:pollDelegate?
    
    //MARK: - Section: Class Methods
    
    /// This button press method checks for valid fields and pushes poll data to parse
    @IBAction func createPoll(sender: AnyObject)  {
        
        if ErrorHandling.emptyStringOrNil(titleOfPoll.text)   {
            ErrorHandling.showAlertWithString("Missing Field", messageText: "Poll is missing a title.", currentViewController: self)
            return
        }
        if ErrorHandling.emptyStringOrNil(descriptionOfPoll.text) || isPlaceHolderText {
            ErrorHandling.showAlertWithString("Missing Field", messageText: "Poll is missing a description", currentViewController: self)
            return
        }
     
        
        sendPollToParse()
    }
    
    /// Send poll data to parse
    func sendPollToParse () {
        myPoll = Poll()
        
        if let optionArr = createOptionArray(myPoll!)  {
            
            addPollDelegate?.addPollItem(myPoll!)
            
            TimelineFeed.startLoadAnimationAndDisableUI(self)
            
            myPoll!.postPoll(pollTitle: titleOfPoll.text, pollDescribtion: descriptionOfPoll.text, arrayWithOptions: optionArr, categoryTypeIndex: categoryPicker.selectedSegmentIndex) { (sucess,error) -> Void in
                
                    TimelineFeed.reEnableUI(self)
                
                if sucess {
                    
                    self.navigationController!.popToRootViewControllerAnimated(true)
                }else{
                    
                    ErrorHandling.showAlertWithString("Error", messageText: "Could not send poll to the server. Please try again.", currentViewController: self)
                }
            }
        }
    }
    
    /**
    Grabs option description from visible cells.
    
    :param: myPoll Parse subclass with Dictionary format.
    :returns: all poll options with 0 votes each, nil if empyty cell describtions.
    */
    func createOptionArray (myPoll:Poll) -> [[String: AnyObject]]?{
        
        for cell in optionsTableView.visibleCells() {
            
            let cellContent:CreatePollTableViewCell = cell as! CreatePollTableViewCell
            let cellIndex:NSIndexPath = optionsTableView.indexPathForCell(cellContent)!
            
            if let cellTextFieldString = cellContent.optionDescription?.text {
                
                let isEmpty:Bool = ErrorHandling.emptyStringOrNil(cellTextFieldString)
                
                if cellIndex.row <= 1 && isEmpty  {
                    //println("nil cell at cellindex: \(cellIndex.row)")
                    ErrorHandling.showAlertWithString("Missing Field", messageText: "Need at least 2 options for poll", currentViewController: self)
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
        
        descriptionOfPoll.delegate = self 
        descriptionOfPoll.text = "Description"
        descriptionOfPoll.textColor = UIColor.lightGrayColor()
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

extension CreatePollViewController:UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView){
        
        println("Works" )
        
         UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.frame.origin.y -= 80
         })
        
        
        
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            isPlaceHolderText = false
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.frame.origin.y += 80
        })
        
        if (textView.text.isEmpty || ErrorHandling.emptyStringOrNil(textView.text)){
            isPlaceHolderText = true 
            textView.text = "Description"
            textView.textColor = UIColor.lightGrayColor()
        }
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
        
        cell.optionDescription.placeholder = cell.placeHolderText[indexPath.row]
        return cell
    }
}



