//
//  PlannerMainCell.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class PlannerCell: UITableViewCell {
    
    var createdDate: Date? {
        didSet {
            let formattedDate = timeAgoStringFromDate(date: createdDate!)
            dateLabel.text = "\(formattedDate ?? "unknown")"
        }
    }
    
    var type: String? {
        didSet {
            typeLabel.text = "\(type ?? "unknown")"
        }
    }
    
    func setup(type: String, createdDate: Date) {
        self.createdDate = createdDate
        self.type = type
    }
    
    let divider = UIView().setupBackground(bgColor: .tableViewSeperator)
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let dateLabel = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .tableViewLightGrey)
    let typeLabel = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsGreen)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        
        background.roundCorners(corners: .all)
//        background.setUpShadow(color: .red, offset: CGSize(width: 0, height: 1), radius: 5, opacity: 1)
        
        background.layer.shadowColor = UIColor.red.cgColor
        background.layer.shadowOffset = CGSize(width: 0, height: 0)
        background.layer.shadowRadius = 5
        background.layer.shadowOpacity = 1
        background.layer.shouldRasterize = true
        background.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        addSubviews(views: [background, divider, typeLabel, dateLabel])
        
        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, bottomPad: -6, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6)
        typeLabel.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 9)
        dateLabel.anchors(top: background.topAnchor, topPad: 6, right: background.rightAnchor, rightPad: -9)
        divider.anchors(top: typeLabel.bottomAnchor, topPad: 5, left: background.leftAnchor, right: background.rightAnchor, height: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
