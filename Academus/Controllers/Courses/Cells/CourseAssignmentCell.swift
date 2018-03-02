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
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.short
            formatter.timeStyle = .none
            guard let assignedDate = assignment?.due_date else {return}
            let dateString = formatter.string(from: assignedDate)
            assignedDateLabel.text = dateString + " - "
            assignmentNameLabel.text = assignment?.name ?? " "
            gradeLabel.text = "\(assignment!.score.text!)"
        }
    }
    
    let cellBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.tableViewLightGrey
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.2
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellBottomBackground: UIView = {
        let view = UILabel()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.navigationsMediumGrey
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
        let assignmentNameLabel: UILabel = {
        let label = UILabel()
//        label.lineBreakMode = .byTruncatingTail
//        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-medium", size: 16)
        label.textColor = UIColor.navigationsWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        }()
    
    let assignedDateLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.font = UIFont(name: "AvenirNext-demibold", size: 16)
        label.textColor = UIColor.tableViewPeriodText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
        let gradeLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "AvenirNext-demibold", size: 14)
            label.textColor = UIColor.tableViewPeriodText
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.tableViewGrey
        selectionStyle = .none
        separatorInset = UIEdgeInsets.zero

        addSubview(cellBackground)
        NSLayoutConstraint.activate([
            cellBackground.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cellBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            cellBackground.leftAnchor.constraint(equalTo: leftAnchor, constant: 6),
            cellBackground.rightAnchor.constraint(equalTo: rightAnchor, constant: -6),
            ])
        
        addSubview(cellBottomBackground)
        NSLayoutConstraint.activate([
            cellBottomBackground.heightAnchor.constraint(equalToConstant: 30),
            cellBottomBackground.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor),
            cellBottomBackground.leftAnchor.constraint(equalTo: cellBackground.leftAnchor),
            cellBottomBackground.rightAnchor.constraint(equalTo: cellBackground.rightAnchor),
            ])
        
        addSubview(assignedDateLabel)
        NSLayoutConstraint.activate([
            assignedDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            assignedDateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            ])
        
        addSubview(assignmentNameLabel)
        NSLayoutConstraint.activate([
            assignmentNameLabel.widthAnchor.constraint(equalToConstant: 275),
            assignmentNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            assignmentNameLabel.leftAnchor.constraint(equalTo: assignedDateLabel.rightAnchor),
            ])
        
        addSubview(gradeLabel)
        NSLayoutConstraint.activate([
//            gradeLabel.topAnchor.constraint(equalTo: assignmentNameLabel.topAnchor, constant: 25),
            gradeLabel.centerYAnchor.constraint(equalTo: cellBottomBackground.centerYAnchor),
            gradeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
