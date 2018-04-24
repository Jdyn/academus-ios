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
            if createdDate! < Date() {
                let formattedDate = timeAgoStringFromDate(date: createdDate!)
                dateLabel.text = "\(formattedDate ?? "unknown")"
            } else {
                let formattedDate = daysBetween(date: createdDate!)
                dateLabel.text = "in \(formattedDate) days"
            }
        }
    }
    
    var type: String? {
        didSet {
            typeLabel.text = "\(type ?? "unknown")"
        }
    }
    
    var color: UIColor? {
        didSet {
            colorView.backgroundColor = color ?? .tableViewLightGrey
            typeLabel.textColor = color
        }
    }
    
    func setup(type: String, createdDate: Date, color: UIColor) {
        self.createdDate = createdDate
        self.type = type
        self.color = color
    }
    
    let divider = UIView().setupBackground(bgColor: .tableViewSeperator)
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let dateLabel = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .tableViewLightGrey)
    let typeLabel = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsGreen)
    let colorView = UIView()
    
    let downArrow = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "downArrow"))
    
    let titleLabel = UILabel()
    let gradeLabel = UILabel()
    let gradeTwoLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        background.roundCorners(corners: .all)
        
        colorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        colorView.layer.cornerRadius = 3
        colorView.layer.masksToBounds = true
        
        addSubviews(views: [background, divider, typeLabel, dateLabel, colorView])
        
        colorView.anchors(top: background.topAnchor, topPad: 6, bottom: background.bottomAnchor, bottomPad: -6, left: leftAnchor, leftPad: 6, width: 3)
        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, bottomPad: -6, left: colorView.rightAnchor, leftPad: 0, right: rightAnchor, rightPad: -6)
        typeLabel.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 12)
        dateLabel.anchors(top: background.topAnchor, topPad: 6, right: background.rightAnchor, rightPad: -9)
        divider.anchors(top: typeLabel.bottomAnchor, topPad: 6, left: background.leftAnchor, right: background.rightAnchor, height: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
