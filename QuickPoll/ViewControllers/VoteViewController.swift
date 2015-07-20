//
//  VoteViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/6/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {
  
  

  //MARK: Outlets
  //
  @IBOutlet weak var tableViewWithOptions: UITableView!
  //
  
  //MARK: Setup
  //
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
  }
  //
  
}


//MARK: TableView Data
//
extension VoteViewController:UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
    var returnCount:Int = 4
    return returnCount
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    
    let cell = tableView.dequeueReusableCellWithIdentifier("optionCell") as! VoteOptionTableViewCell
    return cell
  }
  
}
//


//MARK: TableView Delegate
//
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
//



