//
//  ManageCellType.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

enum ManageCellManager {
    
    case manageIntegrations
    case manageInvites
    case settings
    case help
    case about
    
    func getTitle() -> String{
        switch self {
        case .manageIntegrations: return "Manage Integrations"
        case .manageInvites: return "Manage Invites"
        case .settings: return "Settings"
        case .help: return "Help"
        case .about: return "About"
        }
    }
    
    func getSubtext() -> String{
        switch self {
        case .manageIntegrations: return ""
        case .manageInvites: return ""
        case .settings: return ""
        case .help: return ""
        case .about: return ""
        }
    }
    
    func image() -> UIImage{
        switch self {
        case .manageIntegrations: return #imageLiteral(resourceName: "sync")
        case .manageInvites: return #imageLiteral(resourceName: "personAdd")
        case .settings: return #imageLiteral(resourceName: "settings")
        case .help: return #imageLiteral(resourceName: "help")
        case .about: return #imageLiteral(resourceName: "about")
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .manageIntegrations, .manageInvites: return 0
        case .settings, .help, .about: return 1
        }
    }
    
    func rowCount() -> Int {
        switch self {
        case .manageIntegrations, .manageInvites: return 2
        case .settings, .help, .about: return 3
        }
    }
    
    func cellType() -> CellTypes{
        switch self {
        case .manageIntegrations, .manageInvites: return .manageMediumCell
        case .settings, .help, .about: return .manageSmallCell
        }
    }
}

class ManageSmallCell: MainCell {
    
    override var index: Int? {
        didSet {
            if index == 0 {
                background.setUpShadow(color: .black, offset: CGSize(width: 0, height: -1.5), radius: 1.5, opacity: 0.15)
            } else if index == 1 {
                background.setUpShadow(color: .black, offset: CGSize(width: 0, height: -0.72), radius: 1, opacity: 0.15)
            } else if index == 2 {
                background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 1.5), radius: 1.5, opacity: 0.15)
            }
        }
    }
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let title = UILabel().setUpLabel(text: "", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
    let icon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .navigationsLightGrey
        return view
    }()
    
    override func setTitle(title: String) { self.title.text = title }
    override func setImage(image: UIImage) { self.icon.image = image }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        addSubviews(views: [background, icon, title])
        
        background.anchors(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: centerYAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ManageMediumCell: MainCell {
    
    override var index: Int? {
        didSet {
            if index == 0 {
                background.setUpShadow(color: .black, offset: CGSize(width: 0, height: -1.5), radius: 1.5, opacity: 0.15)
            } else if index == 1 {
                background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 1.5), radius: 1.5, opacity: 0.15)
            }
        }
    }
    
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let title = UILabel().setUpLabel(text: "", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
    let icon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .navigationsGreen
        return view
    }()
    
    override func setTitle(title: String) { self.title.text = title }
    
    override func setImage(image: UIImage) { self.icon.image = image }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        addSubviews(views: [background, icon, title])
        
        background.anchors(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: centerYAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
