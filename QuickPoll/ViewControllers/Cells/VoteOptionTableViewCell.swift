//
//  VoteOptionTableViewCell.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/6/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class VoteOptionTableViewCell: UITableViewCell {

  
  @IBOutlet weak var selectOption: UIButton!
  
  
  
  @IBAction func selectOptionTapped(sender: AnyObject) {
    if selectOption.selected {
      selectOption.selected = false
    }else {
      selectOption.selected = true
    }
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
