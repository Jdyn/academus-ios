//
//  PlannerMainCell.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class PlannerMainCell: UITableViewCell {
    
    var textChangedBlock: ((String) -> Void)?

    func set(title: String, placeholder: String, image: String, secureEntry: Bool, keyboardType: UIKeyboardType){
        setTitle(title: title)
        setPlaceholder(placeholder:  placeholder)
        setKeyboardType(type: keyboardType)
        setImage(image: image)
        setSecureEntry(isSecure: secureEntry)
    }
    
    func setTitle(title: String){}
    func setPlaceholder(placeholder: String){}
    func setKeyboardType(type: UIKeyboardType){}
    func setSecureEntry(isSecure: Bool){}
    func setImage(image: String){}
    func setTextAlignment(textAlignment: NSTextAlignment){}
    func setDatePicker(picker: UIColoredDatePicker) {}
}
