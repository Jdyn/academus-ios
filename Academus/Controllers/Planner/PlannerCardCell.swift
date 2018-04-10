//
//  PlannerCardCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class PlannerCardCell: UITableViewCell {

    var card: PlannerCards? {
        didSet {
            nameLabel.text = card?.name
            if (card?.plannerReminder != nil) {
                let date = card?.plannerReminder?.dateDue
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE, MMMM d @ hh:mm"
                dueDate.text = formatter.string(from: date!)
            } else {
                dueDate.text = ""
            }
        }
    }
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewMediumGrey
        view.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 2, opacity: 0.4)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 20)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let dueDate: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 12)
        label.textColor = .navigationsLightGrey
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        addSubview(background)
        addSubview(nameLabel)
        addSubview(dueDate)
        
        background.anchors(top: topAnchor, topPad: 3, bottom: bottomAnchor, bottomPad: -9, left: leftAnchor, leftPad: 10, right: rightAnchor, rightPad: -10, width: 0, height: 0)
        nameLabel.anchors(top: background.topAnchor, topPad: 12, left: background.leftAnchor, leftPad: 12, width: 0, height: 0)
        dueDate.anchors(top: nameLabel.bottomAnchor, left: background.leftAnchor, leftPad: 12, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
