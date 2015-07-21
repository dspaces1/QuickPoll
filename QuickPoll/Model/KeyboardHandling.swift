//
//  KeyboardHandling.swift
//  QuickPoll
//
//  Created by Diego Urquiza on 7/16/15.
//  Copyright (c) 2015 Diego Urquiza. All rights reserved.
//

import Foundation
import UIKit

///
class KeboardHandling: NSObject {
    
    // MARK: - Section: Class Properties
    
    let view: UIView!
    
    // MARK: - Section: Class Methods

    init (view: UIView!){
        self.view = view
        super.init()
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    /// Finish editing and dismiss the keyboard
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    
    
}