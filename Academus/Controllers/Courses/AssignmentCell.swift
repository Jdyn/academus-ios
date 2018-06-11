//
//  CourseAssignmentCell.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class AssignmentCell: UITableViewCell {
    
    var assignment : Assignment? {
        didSet {
            guard let assignedDate = assignment?.assignedDate else {print("RETURNED"); return }
            guard let dueDate = assignment?.dueDate else {print("RETURNED"); return }
            
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
    
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let titleLabel = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsWhite)
    let dateLabel = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .tableViewLightGrey)
    let gradeLabel = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .navigationsGreen)
    let arrow = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "arrowRight"))

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        background.roundCorners(corners: .all)
        
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 1

        selectedBackgroundView = selectedBackgroundView()
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
    
    func selectedBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .tableViewDarkGrey
        let selectedView = UIView()
        selectedView.backgroundColor =  UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 0.1)
        
        selectedView.layer.cornerRadius = 9
        selectedView.layer.masksToBounds = true
        
        view.addSubview(selectedView)
        selectedView.anchors(top: view.topAnchor, topPad: 9, bottom: view.bottomAnchor, left: view.leftAnchor, leftPad: 9, right: view.rightAnchor, rightPad: -9)
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
