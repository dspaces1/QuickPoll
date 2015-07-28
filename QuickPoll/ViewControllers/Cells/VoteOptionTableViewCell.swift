//
//  VoteOptionTableViewCell.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/6/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class VoteOptionTableViewCell: UITableViewCell {

    //MARK: - Section: Class Properties
  
    @IBOutlet weak var selectOption: UIButton!

    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var optionDescription: UILabel!
    @IBOutlet weak var resultsBar: UIView!
    
    @IBOutlet weak var alignYConstraintOfDescription: NSLayoutConstraint!
    @IBOutlet weak var barWidth: NSLayoutConstraint!
    
    
    
    
    //MARK: - Section: Class Methods
    
    func getBarMaxHeight () -> CGFloat{
        let maxBarWidth = CGRectGetWidth(resultsBar.frame)
        return maxBarWidth
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
}
