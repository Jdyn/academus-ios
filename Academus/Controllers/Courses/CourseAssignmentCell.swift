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
            guard let assignedDate = assignment?.assigned_date else { return }
            guard let dueDate = assignment?.due_date else { return }
            
            if assignedDate > Date() {
                let date = daysBetween(date: dueDate)
                dateLabel.text = date > 1 ? "Due in \(date) days" : "Due in \(date) day"
            } else {
                let date = timeAgoStringFromDate(date: assignedDate)
                dateLabel.text = "Posted \(date!)"
            }
            titleLabel.text = assignment?.name ?? ""
            gradeLabel.text = "\(assignment!.score?.text! ?? "")"
        }
    }
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewMediumGrey
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.font = UIFont.standard
        label.textColor = .navigationsWhite
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.subheader
        label.textColor = .tableViewLightGrey
        return label
    }()
    
    let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.subheader
        label.textColor = .navigationsGreen
        return label
    }()
    
    let arrow: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "arrowRight")
        view.tintColor = .navigationsGreen
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        background.roundCorners(corners: .all)
        
        selectionStyle = .none
        separatorInset = UIEdgeInsets.zero
        
        background.addSubviews(views: [titleLabel, dateLabel, gradeLabel, arrow])
        addSubview(background)
        
        background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 2, opacity: 0.25)
        background.anchors(top: topAnchor, topPad: 9, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 9, right: rightAnchor, rightPad: -9)
        titleLabel.anchors(top: background.topAnchor, topPad: 9, left: background.leftAnchor, leftPad: 12, right: background.rightAnchor, rightPad:  -6, width: 0, height: 0)
        gradeLabel.anchors(top: titleLabel.bottomAnchor, left: background.leftAnchor, leftPad: 12, width: 0, height: 0)
        dateLabel.anchors(top: gradeLabel.bottomAnchor, bottom: background.bottomAnchor, bottomPad: -9, left: background.leftAnchor, leftPad: 12)
        arrow.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 32, height: 32)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
