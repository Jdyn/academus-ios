//
//  SettingsCells.swift
//  Academus
//
//  Created by Jaden Moore on 3/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

enum SettingsCells {
    
    case fingerPrintLock
    case NotifAssignmentPosted
    case NotifCourseGradeUpdated
    case NotifMiscellaneous
    
    func getTitle() -> String{
        
        switch self {
        case .fingerPrintLock: return "Fingerprint lock"
        case .NotifAssignmentPosted: return "Assignment posted"
        case .NotifCourseGradeUpdated: return "Course grade posted"
        case .NotifMiscellaneous: return "Miscellaneous"
        }
    }
    
    func getSubtext() -> String{
        
        switch self {
        case .fingerPrintLock: return ""
        case .NotifAssignmentPosted: return ""
        case .NotifCourseGradeUpdated: return ""
        case .NotifMiscellaneous: return ""
        }
    }
    
    func image() -> UIImage{
        switch self {
        case .fingerPrintLock: return #imageLiteral(resourceName: "fingerprint")
        case .NotifAssignmentPosted: return #imageLiteral(resourceName: "assignmentNotif")
        case .NotifCourseGradeUpdated: return #imageLiteral(resourceName: "courseNotif")
        case .NotifMiscellaneous: return #imageLiteral(resourceName: "miscNotif")
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .fingerPrintLock: return 0
        case .NotifAssignmentPosted, .NotifCourseGradeUpdated, .NotifMiscellaneous: return 1
        }
    }
    
    func rowCount() -> Int {
        switch self {
        case .fingerPrintLock: return 1
        case .NotifAssignmentPosted, .NotifCourseGradeUpdated, .NotifMiscellaneous: return 3
        }
    }
    
    func cellType() -> SettingsCellTypes{
        switch self {
        case .fingerPrintLock: return .mediumCell
        case .NotifAssignmentPosted, .NotifCourseGradeUpdated, .NotifMiscellaneous: return .smallCell
        }
    }
}

