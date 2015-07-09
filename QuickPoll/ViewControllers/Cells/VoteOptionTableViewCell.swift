//
//  VoteOptionTableViewCell.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/6/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class VoteOptionTableViewCell: UITableViewCell {

  //Mark: Outlets
  //
  
  @IBOutlet weak var selectOption: UIButton!
  
  //
  
  
  
  //Mark:Functions
  //
  
  // Animate Selected cell checkbox and deSelect the other checkboxes
  static func selectNewOption (#tableView:UITableView , indexPath:NSIndexPath){
    
    for cell in tableView.visibleCells() {
      
      let cellIndex:NSIndexPath = tableView.indexPathForCell(cell as! UITableViewCell)!
      
      tableView.deselectRowAtIndexPath(cellIndex, animated: true)
      
      let currentCell = tableView.cellForRowAtIndexPath(cellIndex) as! VoteOptionTableViewCell
      
      if cellIndex.row != indexPath.row {
        currentCell.selectOption.selected = false
      }else {
        currentCell.selectOption.selected = true
      }
      
    }
    
  }
  
  //
  
  
  
  //MARK: Setup
  //
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
    
      // Configure the view for the selected state
  }

}
