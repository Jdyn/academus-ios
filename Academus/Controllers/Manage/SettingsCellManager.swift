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
    
    // Section Rows
    case fingerPrintLock
    case notifAssignmentPosted
    case notifCourseGradeUpdated
    case notifMiscellaneous
    
    // Section Headers
    case privacySecurity
    case notifications

    func getTitle() -> String{

        switch self {
        case .fingerPrintLock: return "Fingerprint lock"
        case .notifAssignmentPosted: return "Assignment posted"
        case .notifCourseGradeUpdated: return "Course grade posted"
        case .notifMiscellaneous: return "Miscellaneous"
        case .privacySecurity: return "Privacy and Security"
        case .notifications: return "Notifications"
        }
    }

    func getSubtext() -> String{
        switch self {
        case .fingerPrintLock: return ""
        case .notifAssignmentPosted: return ""
        case .notifCourseGradeUpdated: return ""
        case .notifMiscellaneous: return ""
        default: return ""
        }
    }

    func getImage() -> UIImage{
        switch self {
        case .fingerPrintLock: return #imageLiteral(resourceName: "fingerprint")
        case .notifAssignmentPosted: return #imageLiteral(resourceName: "assignmentNotif")
        case .notifCourseGradeUpdated: return #imageLiteral(resourceName: "courseNotif")
        case .notifMiscellaneous: return #imageLiteral(resourceName: "miscNotif")
        default: return UIImage()
        }
    }
    
    func getHeight() -> CGFloat {
        switch self {
        case .fingerPrintLock: return 55
        case .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous: return 45
        default: return 30
        }
    }

    func getSection() -> Int {
        switch self {
        case .fingerPrintLock: return 0 // Section 0
        case .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous: return 1 // Section 1
        default: return 0
        }
    }

    func rowCount() -> Int {
        switch self {
        case .fingerPrintLock: return 1
        case .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous: return 3
        default: return 0
        }
    }

    func getCellType() -> String {
        switch self {
        case .fingerPrintLock: return "MediumCell"
        case .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous: return "SmallCell"
        default: return ""
        }
    }
}