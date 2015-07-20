//
//  CreatePollTableViewCell.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import UIKit

class CreatePollTableViewCell: UITableViewCell {

  //MARK: variables
  //
  @IBOutlet weak var optionDescription: UITextField!
  
  override func awakeFromNib() {
      super.awakeFromNib()
    optionDescription.delegate = self
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
    
  }
  //
  
}

//Mark: UITextField delegate
//
extension CreatePollTableViewCell:UITextFieldDelegate{
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
//
