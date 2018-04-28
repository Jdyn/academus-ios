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
            typeLabel.adjustsFontSizeToFitWidth = true
            typeLabel.sizeToFit()
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
    
    let divider = UIView().setupBackground(bgColor: .navigationsMediumGrey)
    
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let subBackground = UIView().setupBackground(bgColor: .tableViewGrey)
    
    let dateLabel = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .tableViewLightGrey)
    let typeLabel = UILabel().setUpLabel(text: "", font: UIFont.demiStandard!, fontColor: .navigationsGreen)
    let colorView = UIView()
    
    let downArrow = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "downArrow"))
    
    let titleLabel = UILabel()
    let gradeLabel = UILabel()
    let gradeTwoLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        dateLabel.font = UIFont.demiStandard
        gradeLabel.font = UIFont.standard
        gradeTwoLabel.font = UIFont.standard

        titleLabel.textColor = .navigationsWhite
        titleLabel.font = UIFont.standard
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.lineBreakMode = .byWordWrapping
        
        background.roundCorners(corners: .all)
        background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 2, opacity: 0.25)
        
        colorView.setUpShadow(color: .black, offset: CGSize(width: -2, height: 0), radius: 2, opacity: 0.25)
        subBackground.roundCorners(corners: .bottom)
        
        colorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        colorView.layer.cornerRadius = 3
        colorView.layer.masksToBounds = false
        
        addSubviews(views: [background, divider, typeLabel, dateLabel, titleLabel, colorView, subBackground])
        
        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, bottomPad: -6, left: colorView.rightAnchor, leftPad: 0, right: rightAnchor, rightPad: -6)
        divider.anchors(top: typeLabel.bottomAnchor, topPad: 3, left: background.leftAnchor, right: background.rightAnchor, height: 1)
        
        subBackground.anchors(top: divider.bottomAnchor, topPad: 0, bottom: background.bottomAnchor, left: background.leftAnchor, right: background.rightAnchor)
        
        colorView.anchors(top: background.topAnchor, topPad: 6, bottom: background.bottomAnchor, bottomPad: -6, left: leftAnchor, leftPad: 6, width: 6)
        typeLabel.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 12, right: dateLabel.leftAnchor, rightPad: -6)
        dateLabel.anchors(right: background.rightAnchor, rightPad: -9, centerY: typeLabel.centerYAnchor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
