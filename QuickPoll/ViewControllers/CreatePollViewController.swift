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
    @IBOutlet weak var characterLimit: UILabel!
    
    var scrollViewHeight:CGFloat!
    
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
    
    @IBAction func cancelCreatePoll(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
                    self.dismissViewControllerAnimated(true, completion: nil)
                    //self.navigationController!.popToRootViewControllerAnimated(true)
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
        
        //keboardHandler = KeboardHandling(view: view!)
        
        scrollViewHeight = contentScrollView.contentSize.height
        
        descriptionOfPoll.delegate = self 
        descriptionOfPoll.text = "Description"
        descriptionOfPoll.textColor = UIColor.lightGrayColor()
        
        characterLimit.hidden  = true
        
        
        scrollViewHeight = contentScrollView.contentSize.height
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
    }

    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    
    var currentTextFieldFrame:CGRect?
    var keyboardFrame:CGRect?
    
    func keyboardWillShow(notification: NSNotification) {
        
        var info = notification.userInfo!
        keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
//        scrollViewHeight = contentScrollView.contentSize.height

        contentScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, scrollViewHeight + keyboardFrame!.height)
        
        //scrollIfNeed()
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        contentScrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width, scrollViewHeight)
    }
    
    
    func scrollIfNeed() {
        
        if let frameToShow = currentTextFieldFrame {
            
            
            let defaultKeyboardHeight:CGFloat = 253
            var keyboardHeight:CGFloat
            
            if let Height = keyboardFrame?.height {
                keyboardHeight = Height
            } else {
                keyboardHeight = defaultKeyboardHeight
            }
            
            
            if frameToShow.origin.y > keyboardHeight {
                
                let scrollOffset = frameToShow.origin.y - (UIScreen.mainScreen().bounds.height - keyboardHeight - frameToShow.height )
                contentScrollView.setContentOffset(CGPoint(x: 0, y:  scrollOffset ), animated: true)
                
            } else {
                contentScrollView.setContentOffset(CGPoint(x: 0, y: 0 ), animated: true)
            }
        }
    }


}



// MARK: - Protocols
// MARK: UITextFieldDelegate

extension CreatePollTableViewCell:UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        var textFieldTag = textField.tag + 1
        var nextResponder = textField.superview!.superview!.superview!.viewWithTag(textFieldTag)
        
        if let nextResponder = nextResponder {
            
            nextResponder.becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
            
        }
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        moveCellDelegate?.getTableCellPosition(self)
        characterLimit.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        characterLimit.hidden = true
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = count(textField.text.utf16) + count(string.utf16) - range.length
        
        characterLimit.text =  String(45 - newLength)
        
        return newLength < 45
        
    }
    
}

extension CreatePollViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        descriptionOfPoll.becomeFirstResponder()
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        currentTextFieldFrame = textField.frame
        scrollIfNeed()
        characterLimit.hidden = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        characterLimit.hidden = true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let newLength = count(textField.text.utf16) + count(string.utf16) - range.length

        characterLimit.text =  String(25 - newLength)

        return newLength < 25
        
    }
    
    
}


//pod 'IQKeyboardManager'
extension CreatePollViewController:UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n"){
            
            let descriptionViewFrameY = textView.frame.origin.y * 0.75
            contentScrollView.setContentOffset(CGPoint(x: 0, y: descriptionViewFrameY), animated: true)
            
            
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            let cell = self.optionsTableView.cellForRowAtIndexPath(indexPath) as! CreatePollTableViewCell
            cell.optionDescription.becomeFirstResponder()
            
            return false
        }
        
        return true
    
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        currentTextFieldFrame = textView.frame
        scrollIfNeed()
        
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
            isPlaceHolderText = false
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        
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
        
        cell.optionDescription.tag = 1 + indexPath.row
        
        cell.characterLimit.hidden = true
        
        cell.moveCellDelegate = self
        
        return cell
    }
    
   
}



extension CreatePollViewController:MoveTableViewCellsDelegate {
    
    func getTableCellPosition(cell:CreatePollTableViewCell){
        //find the top of keyboard
    
        //println("cell frame: \(cell.frame) and keyboard frame: \(keyboardFrame)")
        
        //let tableViewFrame:CGRect = cell.convertRect(cell.frame, toView: self.optionsTableView)
        let tableViewCellFrameInView:CGRect = optionsTableView.convertRect(cell.frame, toView: self.contentScrollView)
        currentTextFieldFrame = tableViewCellFrameInView
        scrollIfNeed()
        
//        println(keyboardFrame.origin.y)
//        println("cell frame: \(tableViewCellFrameInView.origin.y)")
//        println("cell frame with respect view: \(tableViewCellFrameInView.origin.y)")
//        
//        let heightOfScreen = UIScreen.mainScreen().bounds.origin.y
//        println(tableViewCellFrameInView.origin.y)
//        
//
//        
//        contentScrollView.setContentOffset(CGPoint(x: 0, y:  tableViewCellFrameInView.origin.y - 153 ), animated: true)
        
        
        
        
    }
}


