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
        view.backgroundColor = .tableViewMediumGrey
        let size = CGSize(width: 0, height: 0)
        view.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 1, opacity: 0.3)
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
        return label
    }()
    
    let periodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 16)
        label.textColor = .tableViewLightGrey
        return label
    }()
    
    let gradeLetterLabel: UILabel = {
        let label = UILabel()
        label.text = "A+"
        label.font = UIFont(name: "AvenirNext-medium", size: 16)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let gradePercentLabel: UILabel = {
        let label = UILabel()
        label.text = "(100.00%)"
        label.font = UIFont(name: "AvenirNext-medium", size: 12)
        label.textColor = .tableViewLightGrey
        return label
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        let stackView = UIStackView(arrangedSubviews: [
            gradeLetterLabel, gradePercentLabel
            ])
        
        stackView.axis = .vertical
        stackView.alignment = .center
        
        addSubview(background)
        addSubview(arrow)
        addSubview(stackView)
        addSubview(periodLabel)
        addSubview(title)


        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -6, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6)
        stackView.anchors(right: arrow.leftAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 0, height: 0)
        periodLabel.anchors(left: background.leftAnchor, leftPad: 6, centerY: background.centerYAnchor, width: 0, height: 0)
        title.anchors(left: periodLabel.rightAnchor, leftPad: 12, centerY: background.centerYAnchor, width: 200, height: 0)
        arrow.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 0, height: 0)
        arrow.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
