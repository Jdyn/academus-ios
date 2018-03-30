//
//  SmallCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageSmallCell: MainCell {
    
    override var index: Int? {
        didSet {
            if index == 0 {
                background.setUpShadow(color: .black, offset: CGSize(width: 0, height: -1.5), radius: 1.5, opacity: 0.15)
            } else if index == 1 {
                background.setUpShadow(color: .black, offset: CGSize(width: 0, height: -0.72), radius: 1, opacity: 0.15)
            } else if index == 2 {
                background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 1.5), radius: 1.5, opacity: 0.15)
            }
        }
    }
    
    let background: UIView = {
        let view = UIView()
        let num: Int?
        view.backgroundColor = .tableViewMediumGrey

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
        return view
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
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        addSubview(background)
        addSubview(icon)
        addSubview(title)
        
        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -0, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: centerYAnchor, width: 0, height: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
