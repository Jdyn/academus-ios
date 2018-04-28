//
//  PlannerMainCell.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class PlannerCell: UITableViewCell {
    
    var assignments: [PlannerCard.AffectingAssignment]? {
        didSet {
            if let assCount = assignments?.count {
                if assCount > 0 {
                    buttons.removeAll()
                    for _ in 0...assCount - 1 {
                        let button = UIButton()
                        buttons.append(button)
                    }
                }
            }
        }
    }
    
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
    
    let divider = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let subBackground = UIView().setupBackground(bgColor: .tableViewGrey)
    
    let dateLabel = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .tableViewLightGrey)
    let typeLabel = UILabel().setUpLabel(text: "", font: UIFont.demiStandard!, fontColor: .navigationsGreen)
    let colorView = UIView()
    
    let downArrow = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "downArrow"))
    
    let titleLabel = UILabel()
    let gradeLabel = UILabel()
    let gradeTwoLabel = UILabel()
    let stack = UIStackView()
    var buttons = [UIButton]()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        dateLabel.font = UIFont.demiStandard
        gradeLabel.font = UIFont.standard
        gradeTwoLabel.font = UIFont.standard
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.adjustsFontSizeToFitWidth = true

        titleLabel.textColor = .navigationsWhite
        titleLabel.font = UIFont.standard
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.lineBreakMode = .byWordWrapping
        
        background.layer.cornerRadius = 16
        background.layer.masksToBounds = false
        background.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 2, opacity: 0.25)
        
        
        subBackground.layer.cornerRadius = 16
        subBackground.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        subBackground.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 2, opacity: 0.25)

        colorView.layer.cornerRadius = 12
        colorView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        colorView.setUpShadow(color: .black, offset: CGSize(width: -2, height: 0), radius: 2, opacity: 0.25)
        
        addSubviews(views: [colorView, background, divider, typeLabel, dateLabel, titleLabel, subBackground])
        
        colorView.anchors(top: background.topAnchor, topPad: 0.5, bottom: background.bottomAnchor, bottomPad: -0.5, left: leftAnchor, leftPad: 9, width: 64)
        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, bottomPad: -6, left: leftAnchor, leftPad: 21, right: rightAnchor, rightPad: -9)
        divider.anchors(top: typeLabel.bottomAnchor, topPad: 3, left: background.leftAnchor, right: background.rightAnchor, height: 1)
        
        subBackground.anchors(top: divider.bottomAnchor, topPad: 0, bottom: background.bottomAnchor, left: background.leftAnchor, right: background.rightAnchor)
        
        typeLabel.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 12, right: dateLabel.leftAnchor, rightPad: -6)
        dateLabel.anchors(right: background.rightAnchor, rightPad: -9, centerY: typeLabel.centerYAnchor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
