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
            guard let assignedDate = assignment?.due_date else {return}
            let date = timeAgoStringFromDate(date: assignedDate)
            dateLabel.text = "Posted: \(date!)"
            titleLabel.text = assignment?.name ?? " "
            gradeLabel.text = "\(assignment!.score.text!)"
        }
    }
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let size = CGSize(width: 0, height: 0)
        view.setUpShadow(color: .black, offset: size, radius: 1.5, opacity: 0.25)
        return view
    }()

        let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = UIFont(name: "AvenirNext-medium", size: 16)
        label.textColor = .navigationsWhite
        return label
        }()
    
    let dateLabel: UILabel = {
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
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(gradeLabel)

        background.anchors(top: topAnchor, topPad: 3, bottom: bottomAnchor, bottomPad: -9, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
        titleLabel.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 6, width: 300, height: 0)
        dateLabel.anchors(bottom: gradeLabel.topAnchor, bottomPad: -6, left: background.leftAnchor, leftPad: 6, width: 0, height: 0)
        dateLabel.anchors(top: titleLabel.bottomAnchor, topPad: -6, left: background.leftAnchor, leftPad: 6, width: 0, height: 0)
        gradeLabel.anchors(bottom: background.bottomAnchor, bottomPad: -6, left: background.leftAnchor, leftPad: 6, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
