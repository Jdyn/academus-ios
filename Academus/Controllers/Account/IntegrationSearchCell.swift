//
//  IntegrationSearchCell.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 5/11/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class IntegrationSearchCell: UITableViewCell {
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let title = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsWhite)
    let location = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .navigationsLightGrey)
    let icon = UIImageView(image: #imageLiteral(resourceName: "school"))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        background.roundCorners(corners: .all)
        
        title.adjustsFontSizeToFitWidth = true
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        icon.tintColor = .white
        
        let textView = UIView()
        textView.addSubviews(views: [title, location])
        addSubviews(views: [background, icon, textView])
        
        title.anchors(top: textView.topAnchor, bottom: location.topAnchor, left: textView.leftAnchor, right: textView.rightAnchor)
        location.anchors(top: title.bottomAnchor, bottom: textView.bottomAnchor, left: textView.leftAnchor, right: textView.rightAnchor)
        
        background.anchors(top: topAnchor, topPad: 9, bottom: bottomAnchor, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 16, centerY: background.centerYAnchor, width: 32, height: 32)
        textView.anchors(left: icon.rightAnchor, leftPad: 16, right: background.rightAnchor, rightPad: -16, centerY: background.centerYAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
