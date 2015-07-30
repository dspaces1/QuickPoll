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
    @IBOutlet weak var resultsBarImage: UIImageView!
    
    @IBOutlet weak var alignYConstraintOfDescription: NSLayoutConstraint!
    @IBOutlet weak var barWidth: NSLayoutConstraint!
    
    let imageArray:[String] = ["FirstBar","SecondBar","ThirdBar","FourthBar"]
    
    //MARK: - Section: Class Methods
    
    func getBarMaxWidth () -> CGFloat{
        let maxBarWidth = resultsBar.frame.width//UIScreen.mainScreen().bounds.width - 40 //CGRectGetWidth(resultsBar.frame)
        return maxBarWidth
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
}
