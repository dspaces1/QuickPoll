//
//  MyPollsViewController.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit
import Parse

class MyPollsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var polls: [Poll] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let pollsFromThisUser = Poll.query()
    pollsFromThisUser?.whereKey("user", equalTo: PFUser.currentUser()!)
    pollsFromThisUser?.includeKey("user")
    pollsFromThisUser?.orderByDescending("createdAt")
    
    pollsFromThisUser?.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
      self.polls = result as? [Poll] ?? []
      self.tableView.reloadData()
      //println(self.polls)
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */
}

extension MyPollsViewController:UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return polls.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("myPollCell", forIndexPath: indexPath) as! MyPollsTableViewCell
    
    cell.title.text = polls[indexPath.row].title
    cell.username.text = polls[indexPath.row].user?.username
    cell.categoryImage.image = UIImage(named:Poll.getCategoryImageString(polls[indexPath.row].category))
    
    return cell
    
  }
  
}
