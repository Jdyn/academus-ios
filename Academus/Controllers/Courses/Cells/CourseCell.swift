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
            nameLabel.text = course?.name
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
        view.layer.shadowOffset = CGSize(width: 0, height:3)
        view.layer.shadowRadius = 1
        view.layer.shadowOpacity = 0.1
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        return view
    }()
    
    let nameLabel: UILabel = {
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
        
        addSubview(background)
        addSubview(periodLabel)
        addSubview(nameLabel)
        addSubview(gradePercentLabel)
        addSubview(gradeLetterLabel)

        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
        periodLabel.anchors(left: background.leftAnchor, leftPad: 6, centerY: centerYAnchor, width: 0, height: 0)
        nameLabel.anchors(left: periodLabel.rightAnchor, leftPad: 6, centerY: centerYAnchor, width: 0, height: 0)
        gradeLetterLabel.anchors(centerX: gradePercentLabel.centerXAnchor, centerY: centerYAnchor, width: 0, height: 0)
        gradePercentLabel.anchors(top: gradeLetterLabel.bottomAnchor, right: background.rightAnchor, rightPad: -12, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
