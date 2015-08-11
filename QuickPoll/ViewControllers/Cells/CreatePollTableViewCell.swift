//
//  CreatePollTableViewCell.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

protocol MoveTableViewCellsDelegate:NSObjectProtocol {
    func getTableCellPosition(cell:CreatePollTableViewCell)
}

class CreatePollTableViewCell: UITableViewCell {

    
    weak var moveCellDelegate:MoveTableViewCellsDelegate?
    
    let placeHolderText:[String] = ["Option 1","Option 2", "Option 3", "Option 4"]
    
    //MARK - Section: Class Properties
    
    @IBOutlet weak var optionDescription: UITextField!
    @IBOutlet weak var characterLimit: UILabel!
  
    //MARK - Section: Class Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionDescription.delegate = self
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
}

//MARK: - Protocols
//MARK: UITextFieldDelegate

extension CreatePollTableViewCell:UITextFieldDelegate{
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
}

