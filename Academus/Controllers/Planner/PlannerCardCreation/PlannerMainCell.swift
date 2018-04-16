//
//  PlannerMainCell.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class PlannerMainCell: UITableViewCell {
    
    var type: CardCreateType!
    var textChangedBlock: ((String) -> Void)?
    
    var pickerOptions: [String]!{
        didSet{
            pickerOptionsSet()
        }
    }

    func set(placeholder: String, secureEntry: Bool, keyboardType: UIKeyboardType){
        setPlaceholder(placeholder:  placeholder)
        setKeyboardType(type: keyboardType)
        setSecureEntry(isSecure: secureEntry)
    }
    
    func setPlaceholder(placeholder: String){}
    func setKeyboardType(type: UIKeyboardType){}
    func setSecureEntry(isSecure: Bool){}
    func setTextAlignment(textAlignment: NSTextAlignment){}
    func setDatePicker(picker: UIColoredDatePicker) {}
    func pickerOptionsSet() {}
}
