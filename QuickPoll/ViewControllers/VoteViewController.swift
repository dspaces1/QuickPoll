//
//  VoteViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/6/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class VoteViewController: UIViewController {

  @IBOutlet weak var tableViewWithOptions: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
}


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


extension VoteViewController:UITableViewDelegate {

  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){

    VoteOptionTableViewCell.selectNewOption(tableView: tableViewWithOptions, indexPath: indexPath)
  
  }
    
    
}
  



