//
//  MyPollsTableViewCell.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/17/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class MyPollsTableViewCell: UITableViewCell {

  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var categoryImage: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
