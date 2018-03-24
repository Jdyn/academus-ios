//
//  SettingsBaseCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/21/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class SettingsBaseCell: UITableViewCell {
    
    var type: SettingsCellTypes!
    var index: Int?
    
    func set(title: String, image: UIImage, subtext: String){
        setTitle(title: title)
        setImage(image: image)
        setSubtext(text: subtext)
    }
    
    func setTitle(title: String){}
    func setImage(image: UIImage){}
    func setSubtext(text: String){}
}
