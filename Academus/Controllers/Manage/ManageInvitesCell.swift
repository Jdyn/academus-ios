//
//  ManageInvitesCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/25/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageInvitesCell: UITableViewCell {
    
    var invite: Invite? {
        didSet {
            inviteCode.text! = "Invite Code: \(invite?.code ?? "Error")"
            if invite?.redeemed == false {
                circle.backgroundColor = .navigationsGreen
                redeemer.text! = "Code not used yet!"
            } else {
                guard let name = invite?.redeemer_name else {return}
                redeemer.text! = "Code used by \(name)"
                circle.backgroundColor = .tableViewLightGrey
            }
        }
    }
    
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let inviteCode = UILabel().setUpLabel(text: "", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
    let redeemer = UILabel().setUpLabel(text: "", font: UIFont.UISubtext!, fontColor: .tableViewLightGrey)
    
    let circle: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.size.width/2
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none

        addSubviews(views: [background, inviteCode, redeemer, circle])
        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6)
        circle.anchors(left: background.leftAnchor, leftPad: 12, centerY: background.centerYAnchor, width: 10, height: 10)
        inviteCode.anchors(top: background.topAnchor, topPad: 14, left: circle.rightAnchor, leftPad: 12)
        redeemer.anchors(bottom: background.bottomAnchor, bottomPad: -14, left: inviteCode.leftAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
