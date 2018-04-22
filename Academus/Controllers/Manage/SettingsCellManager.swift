//
//  SettingsCells.swift
//  Academus
//
//  Created by Jaden Moore on 3/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

enum SettingsCellManager {
    
    // Section 0 Rows
    case appLock
    
    // Section 1 Rows
    case notifSettings
    case notifAssignmentPosted
    case notifCourseGradeUpdated
    case notifMiscellaneous
    
    // Section Headers
    case privacySecurity
    case notifications

    func getTitle() -> String{

        switch self {
        case .appLock: return ""
        case .notifSettings: return "Manage Notifications"
        case .notifAssignmentPosted: return "Assignment posted"
        case .notifCourseGradeUpdated: return "Course grade posted"
        case .notifMiscellaneous: return "Miscellaneous"
        case .privacySecurity: return "Privacy and Security"
        case .notifications: return "Notifications"
        }
    }

    func getSubtext() -> String{
        switch self {
//        case .appLock: return "Feature coming soon"
//        case .notifAssignmentPosted: return "Feature coming soon"
//        case .notifCourseGradeUpdated: return "Feature coming soon"
//        case .notifMiscellaneous: return "Feature coming soon"
//        case .notifications: return ""
        default: return ""
        }
    }

    func getImage() -> UIImage{
        switch self {
        case .appLock: return #imageLiteral(resourceName: "fingerprint")
        case .notifSettings: return #imageLiteral(resourceName: "notification")
        case .notifAssignmentPosted: return #imageLiteral(resourceName: "assignmentNotif")
        case .notifCourseGradeUpdated: return #imageLiteral(resourceName: "courseNotif")
        case .notifMiscellaneous: return #imageLiteral(resourceName: "miscNotif")
        default: return UIImage()
        }
    }
    
    func getHeight() -> CGFloat {
        switch self {
        case .appLock: return 55
        case .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous: return 55
        case .notifSettings: return 110
        default: return 0
        }
    }

    func getSection() -> Int {
        switch self {
        case .appLock: return 0 // Section 0
        case .notifSettings, .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous: return 1 // Section 1
        default: return 0
        }
    }

    func getCellType() -> String {
        switch self {
        case .appLock: return "FingerprintCell"
        case .notifSettings, .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous: return "NotificationCell"
        default: return ""
        }
    }
}
