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
            let teacher = course?.teacher?.name
            title.text = course?.name
            periodLabel.text = "\(course?.period ?? 0)"
            gradeLetterLabel.text = course?.grade?.letter
            gradePercentLabel.text = "(\(coursePercent ?? 0.0))"
            teacherName.text = teacher ?? "Unknown"
        }
    }
    
    let teacherName = UILabel().setUpLabel(text: "", font: UIFont.subtext!, fontColor: .tableViewLightGrey)

    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewMediumGrey
        view.layer.cornerRadius = 12
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
        label.font = UIFont.standard
        label.textColor = .navigationsWhite
        return label
    }()
    
    let periodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.subheader
        label.textColor = .tableViewLightGrey
        return label
    }()
    
    let gradeLetterLabel: UILabel = {
        let label = UILabel()
        label.text = "A+"
        label.font = UIFont.standard!
        label.textColor = .navigationsWhite
        return label
    }()
    
    let gradePercentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.subheader
        label.textColor = .tableViewLightGrey
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        
        selectedBackgroundView = selectedBackgroundView()
        
        let gradeStackView = UIStackView(arrangedSubviews: [ gradeLetterLabel, gradePercentLabel ])
        gradeStackView.axis = .vertical
        gradeStackView.alignment = .center
        
        let titleStackView = UIStackView(arrangedSubviews: [teacherName, title])
        titleStackView.axis = .vertical
        titleStackView.alignment = .leading
        
        background.addSubviews(views: [arrow, gradeStackView, titleStackView, periodLabel])
        
        addSubview(background)
        
        background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 2, opacity: 0.25)
        background.anchors(top: topAnchor, topPad: 9, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 9, right: rightAnchor, rightPad: -9)
        
        titleStackView.anchors(left: periodLabel.rightAnchor, leftPad: 9, right: gradeStackView.leftAnchor, rightPad: -6, centerY: background.centerYAnchor)
        gradeStackView.anchors(right: arrow.leftAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 55, height: 0)
        
        periodLabel.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor, width: 0, height: 0)
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
