//
//  PlannerCardCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class PlannerCardCell: UITableViewCell {

    var card: PlannerCards? {
        didSet {
            nameLabel.text = card?.name
        }
    }
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.4
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 16)
        label.textColor = .navigationsWhite
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewGrey
        selectionStyle = .none
        
        addSubview(background)
        addSubview(nameLabel)
        
        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, bottomPad: -6,left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
        nameLabel.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 6, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
