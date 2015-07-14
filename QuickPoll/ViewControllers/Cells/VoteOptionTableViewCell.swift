//
//  VoteOptionTableViewCell.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/6/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class VoteOptionTableViewCell: UITableViewCell {

  //MARK: Outlets
  //
  
  @IBOutlet weak var selectOption: UIButton!
  
  //
  
  
  
  //MARK: Functions
  //
  
  // Animate Selected cell checkbox and deSelect the other checkboxes
  static func selectNewOptionAnimation (#tableView:UITableView , indexPath:NSIndexPath){
    
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
  
  //
  
  
  
  //MARK: Setup
  //
  
  override func awakeFromNib() {
      super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
  }
  
  //

}
