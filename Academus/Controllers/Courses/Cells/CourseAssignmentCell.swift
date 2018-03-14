//
//  CourseAssignmentCell.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CourseAssignmentCell: UITableViewCell {
    
    var assignment : Assignment? {
        didSet {
            nameLabel.text = assignment?.name ?? " "
            gradeLabel.text = "\(assignment!.score.text!)"
            guard let assignedDate = assignment?.due_date else {return}
            let date = timeAgoStringFromDate(date: assignedDate)
            assignedDateLabel.text = date!
        }
    }
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.1
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        return view
    }()
    
    let bottomBackground: UIView = {
        let view = UILabel()
        view.clipsToBounds = true
        view.backgroundColor = .navigationsMediumGrey
        view.layer.cornerRadius = 5
        return view
    }()
    
        let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = UIFont(name: "AvenirNext-medium", size: 16)
        label.textColor = .navigationsWhite
        return label
        }()
    
    let assignedDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 14)
        label.textColor = .tableViewPeriodText
        return label
    }()
    
    let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 14)
        label.textColor = .tableViewPeriodText
        return label
        }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewGrey
        selectionStyle = .none
        separatorInset = UIEdgeInsets.zero

        addSubview(background)
        addSubview(bottomBackground)
        addSubview(nameLabel)
        addSubview(assignedDateLabel)
        addSubview(gradeLabel)

        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
        bottomBackground.anchors(bottom: background.bottomAnchor, left: background.leftAnchor, right: background.rightAnchor, width: 0, height: 30)
        nameLabel.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 6, width: 350, height: 0)
        assignedDateLabel.anchors(bottom: bottomBackground.topAnchor, bottomPad: -6, left: background.leftAnchor, leftPad: 6, width: 0, height: 0)
        gradeLabel.anchors(left: bottomBackground.leftAnchor, leftPad: 6, centerY: bottomBackground.centerYAnchor, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
