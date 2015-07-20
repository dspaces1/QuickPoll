//
//  CreatePollViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class CreatePollViewController: UIViewController {

  
  //MARK: Outlets
  //
  @IBOutlet weak var contentScrollView: UIScrollView!
  @IBOutlet weak var optionsTableView: UITableView!
  @IBOutlet weak var categoryPicker: UISegmentedControl!
  @IBOutlet weak var titleOfPoll: UITextField!
  @IBOutlet weak var descriptionOfPoll: UITextView!
  var keboardHandler:KeboardHandling!
  //
  
  //MARK: Fuctions
  //
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
    }
    
  }
  
  
  // Get all visible cell and check if the first 2 are nil or empty
  func createOptionArray (myPoll:Poll) -> [NSDictionary]?{
    
    var optionArr:[NSDictionary]? = [NSDictionary]()
    
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
        
        return optionArr
      }
      
    }
    return nil
  }
  
  //
  
  
  //MARK: Setup
  //
  override func viewDidLoad() {
    super.viewDidLoad()
    self.automaticallyAdjustsScrollViewInsets = false
    titleOfPoll.delegate = self
    keboardHandler = KeboardHandling(view: view!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  //
  
}

//MARK: UI Text Field delegate
//

extension CreatePollViewController:UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    return true
  }
}

//


//MARK: Table View Data Source
//
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
//

