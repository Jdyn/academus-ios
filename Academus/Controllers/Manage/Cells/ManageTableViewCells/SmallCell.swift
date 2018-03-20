//
//  SmallCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class SmallCell: BaseCell {
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        view.layer.cornerRadius = 5
//        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
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
        view.tintColor = .navigationsLightGrey
        view.tintColor = .tableViewSeperator
        return view
    }()
    
    override func setTitle(title: String) {
        self.title.text = title
    }
    
    override func setImage(image: UIImage) {
        self.icon.image = image
    }
    
    
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewGrey
        selectionStyle = .gray

//        addSubview(background)
        addSubview(icon)
        addSubview(title)
        
//        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -3, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -12, width: 0, height: 0)
        icon.anchors(left: leftAnchor, leftPad: 12, centerY: centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 18, centerY: centerYAnchor, width: 0, height: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
