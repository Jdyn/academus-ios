//
//  CourseCell.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/21/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {

    var course: Course? {
        didSet {
            
            let coursePercent = Double(exactly: (course?.grade?.percent)!)?.rounded(toPlaces: 1)
            title.text = course?.name
            periodLabel.text = "\(course?.period ?? 0)"
            gradeLetterLabel.text = course?.grade?.letter
            gradePercentLabel.text = "(\(coursePercent ?? 0.0))"

        }
    }
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 3.5
        view.layer.shadowOpacity = 0.2
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        return view
    }()
    
    let arrow: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "arrowRight")
        view.tintColor = .navigationsGreen
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 16)
        label.textColor = .navigationsWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let periodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 16)
        label.textColor = .tableViewPeriodText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradeLetterLabel: UILabel = {
        let label = UILabel()
        label.text = "A+"
        label.font = UIFont(name: "AvenirNext-medium", size: 16)
        label.textColor = .navigationsWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradePercentLabel: UILabel = {
        let label = UILabel()
        label.text = "(100.00%)"
        label.font = UIFont(name: "AvenirNext-medium", size: 12)
        label.textColor = .tableViewPeriodText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewGrey
        selectionStyle = .none
        accessoryType = .detailDisclosureButton
        addSubview(background)
        addSubview(periodLabel)
        addSubview(title)
        addSubview(gradePercentLabel)
        addSubview(gradeLetterLabel)
        addSubview(arrow)

        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, bottomPad: -6, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
        periodLabel.anchors(left: background.leftAnchor, leftPad: 6, centerY: centerYAnchor, width: 0, height: 0)
        title.anchors(left: periodLabel.rightAnchor, leftPad: 12, centerY: centerYAnchor, width: 200, height: 0)
        arrow.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 0, height: 0)
        gradeLetterLabel.anchors(centerX: gradePercentLabel.centerXAnchor, centerY: centerYAnchor, width: 0, height: 0)
        gradePercentLabel.anchors(top: gradeLetterLabel.bottomAnchor, right: arrow.leftAnchor, rightPad: -6, width: 0, height: 0)
        arrow.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
