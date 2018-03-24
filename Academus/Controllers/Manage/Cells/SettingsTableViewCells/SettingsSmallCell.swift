//
//  SettingsSmallCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/21/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class SettingsSmallCell: SettingsBaseCell {
    
    override var index: Int? {
        didSet {
            
        }
    }
    
    let background: UIView = {
        let view = UIView()
        let num: Int?
        view.backgroundColor = .tableViewLightGrey
        //        view.layer.cornerRadius = 5
        //        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        //        let size = CGSize(width: 0, height: -2)
        //        view.setUpShadow(color: .black, offset: size, radius: 2, opacity: 0.3)
        
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 14)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let icon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .navigationsGreen
        return view
    }()
    
    let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.thumbTintColor = .navigationsWhite
        toggle.onTintColor = .navigationsGreen
        toggle.tintColor = .navigationsWhite
        toggle.transform = CGAffineTransform(scaleX: 0.60, y: 0.60)
        return toggle
    }()
    
    override func setTitle(title: String) {
        self.title.text = title
    }
    
    override func setImage(image: UIImage) {
        self.icon.image = image
    }
    
    var cellIndex: Int?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewGrey
        selectionStyle = .none
        
        addSubview(background)
        addSubview(icon)
        addSubview(title)
        addSubview(toggle)
        
        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -0, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: centerYAnchor, width: 0, height: 0)
        toggle.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
