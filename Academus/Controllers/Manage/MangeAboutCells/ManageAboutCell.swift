//
//  ManageAboutCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageAboutCell: MainCell {

    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let title = UILabel().setUpLabel(text: "", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
    let subtext = UILabel().setUpLabel(text: "hello", font: UIFont.UISubtext!, fontColor: .navigationsWhite)
    
    override func setTitle(title: String) {
        self.title.text! = title
    }
    
    override func setSubtext(text: String) {
        self.subtext.text! = text
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        addSubviews(views: [background, subtext, title])
        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -6, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6)
        title.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 12)
        subtext.anchors(top: title.bottomAnchor, topPad: 6, left: background.rightAnchor, leftPad: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
