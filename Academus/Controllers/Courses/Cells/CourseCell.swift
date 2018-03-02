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
            gradePercentLabel.text = "(\(coursePercent ?? 0.0)%)"

        }
    }
    
    let cellBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tableViewLightGrey
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = 0.2
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 16)
        label.textColor = UIColor.navigationsWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let periodLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 16)
        label.textColor = UIColor.tableViewPeriodText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradeLetterLabel: UILabel = {
        let label = UILabel()
        label.text = "A+"
        label.font = UIFont(name: "AvenirNext-demibold", size: 16)
        label.textColor = UIColor.navigationsWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradePercentLabel: UILabel = {
        let label = UILabel()
        label.text = "(100.00%)"
        label.font = UIFont(name: "AvenirNext-demibold", size: 12)
        label.textColor = UIColor.tableViewPeriodText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.tableViewGrey
        selectionStyle = .none
        
        addSubview(cellBackground)
        NSLayoutConstraint.activate([
            cellBackground.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            cellBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            cellBackground.leftAnchor.constraint(equalTo: leftAnchor, constant: 6),
            cellBackground.rightAnchor.constraint(equalTo: rightAnchor, constant: -6),
            ])
        
        addSubview(periodLabel)
        NSLayoutConstraint.activate([
            periodLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            periodLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: periodLabel.leftAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        

        
        addSubview(gradeLetterLabel)
        NSLayoutConstraint.activate([
            gradeLetterLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -18),
            gradeLetterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        addSubview(gradePercentLabel)
        NSLayoutConstraint.activate([
            gradePercentLabel.topAnchor.constraint(equalTo: gradeLetterLabel.bottomAnchor, constant: -5),
            gradePercentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
