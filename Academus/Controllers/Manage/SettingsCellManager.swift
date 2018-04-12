////
////  SettingsCells.swift
////  Academus
////
////  Created by Jaden Moore on 3/20/18.
////  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
////
//
//import UIKit
//import Locksmith
//
//enum SettingsCellManager {
//
//    case fingerPrintLock
//    case NotifAssignmentPosted
//    case NotifCourseGradeUpdated
//    case NotifMiscellaneous
//
//    func getTitle() -> String{
//
//        switch self {
//        case .fingerPrintLock: return "Fingerprint lock"
//        case .NotifAssignmentPosted: return "Assignment posted"
//        case .NotifCourseGradeUpdated: return "Course grade posted"
//        case .NotifMiscellaneous: return "Miscellaneous"
//        }
//    }
//
//    func getSubtext() -> String{
//        switch self {
//        case .fingerPrintLock: return ""
//        case .NotifAssignmentPosted: return ""
//        case .NotifCourseGradeUpdated: return ""
//        case .NotifMiscellaneous: return ""
//        }
//    }
//
//    func image() -> UIImage{
//        switch self {
//        case .fingerPrintLock: return #imageLiteral(resourceName: "fingerprint")
//        case .NotifAssignmentPosted: return #imageLiteral(resourceName: "assignmentNotif")
//        case .NotifCourseGradeUpdated: return #imageLiteral(resourceName: "courseNotif")
//        case .NotifMiscellaneous: return #imageLiteral(resourceName: "miscNotif")
//        }
//    }
//
//    func getSection() -> Int {
//        switch self {
//        case .fingerPrintLock: return 0 // Section 0
//        case .NotifAssignmentPosted, .NotifCourseGradeUpdated, .NotifMiscellaneous: return 1 // Section 1
//        }
//    }
//
//    func rowCount() -> Int {
//        switch self {
//        case .fingerPrintLock: return 1
//        case .NotifAssignmentPosted, .NotifCourseGradeUpdated, .NotifMiscellaneous: return 3
//        }
//    }
//
//    func cellType() -> CellTypes{
//        switch self {
//        case .fingerPrintLock: return .mediumCell
//        case .NotifAssignmentPosted, .NotifCourseGradeUpdated, .NotifMiscellaneous: return .smallCell
//        }
//    }
//}
//
//class SettingsSmallCell: MainCell {
//
//    override var index: Int? {
//        didSet {
//
//        }
//    }
//
//    let background: UIView = {
//        let view = UIView()
//        let num: Int?
//        view.backgroundColor = .tableViewMediumGrey
//        return view
//    }()
//
//    let title: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "AvenirNext-medium", size: 14)
//        label.textColor = .navigationsWhite
//        return label
//    }()
//
//    let icon: UIImageView = {
//        let view = UIImageView()
//        view.tintColor = .navigationsGreen
//        return view
//    }()
//
//    let toggle: UISwitch = {
//        let toggle = UISwitch()
//        toggle.thumbTintColor = .navigationsWhite
//        toggle.onTintColor = .navigationsGreen
//        toggle.tintColor = .navigationsWhite
//        toggle.transform = CGAffineTransform(scaleX: 0.60, y: 0.60)
//        return toggle
//    }()
//
//    override func setTitle(title: String) {
//        self.title.text = title
//    }
//
//    override func setImage(image: UIImage) {
//        self.icon.image = image
//    }
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .tableViewDarkGrey
//        selectionStyle = .none
//
//        addSubview(background)
//        addSubview(icon)
//        addSubview(title)
//        addSubview(toggle)
//
//        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -0, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
//        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: centerYAnchor, width: 20, height: 20)
//        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: centerYAnchor, width: 0, height: 0)
//        toggle.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 0, height: 0)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
//class SettingsMediumCell: MainCell {
//
//    let background: UIView = {
//        let view = UIView()
//        view.backgroundColor = .tableViewMediumGrey
//        return view
//    }()
//
//    let title: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "AvenirNext-medium", size: 14)
//        label.textColor = .navigationsWhite
//        return label
//    }()
//
//    let icon: UIImageView = {
//        let view = UIImageView()
//        view.tintColor = .navigationsGreen
//        return view
//    }()
//
//    override func setTitle(title: String) {
//        self.title.text = title
//    }
//
//    override func setImage(image: UIImage) {
//        self.icon.image = image
//    }
//
//
//
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .tableViewDarkGrey
//        selectionStyle = .none
//
//        addSubview(background)
//        addSubview(icon)
//        addSubview(title)
//
//        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: 0, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
//        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: centerYAnchor, width: 20, height: 20)
//        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: centerYAnchor, width: 0, height: 0)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
//
