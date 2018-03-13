//
//  BaseCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/12/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    
    var type: CellType!
    var textChangedBlock: ((String) -> Void)?
    var pickerOptions: [String]!{
        didSet{
            pickerOptionsSet()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setForm(title: String, placeholder: String, keyboardType: UIKeyboardType){
        set(title: title, placeholder: placeholder, image: "", secureEntry: false, keyboardType: keyboardType)
    }
    
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
    func pickerOptionsSet(){}
    
}
