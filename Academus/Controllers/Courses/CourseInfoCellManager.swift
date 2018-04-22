//
//  CourseInfoCellManager.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum CourseInfoCellManager {
    
    // Course Rows
    case courseName
    case customName
    case period
    case classroomNumber
    
    // Teacher Rows
    case teacherName
    case email
    
    // Stats Rows
    case total
    case average
    case highest
    case lowest
    
    // Section Headers
    case courseInfo
    case teacherInfo
    case statsInfo
    
    func getTitle() -> String {
        switch self {
        case .courseInfo: return "Course Information"
        case .teacherInfo: return "Teacher Information"
        case .statsInfo: return "Course Statistics"
        case .courseName: return "Course Name"
        case .customName: return "Custom Course Name"
        case .period: return "Period"
        case .classroomNumber: return "Classroom Number"
        case .teacherName: return "Teacher Name"
        case .email: return "Teacher Email"
        case .total: return "Total Students"
        case .average: return "Average Grade"
        case .highest: return "Highest Grade"
        case .lowest: return "Lowest Grade"
        }
    }
    
    func getAltSubtext() -> String {
        switch self {
        case .courseName: return "No Course Name Available"
        case .customName: return "No Custom Name Set"
        case .period: return "No Period Number Available"
        case .classroomNumber: return "No Classroom Number Available"
        case .teacherName: return "No Teacher Name Available"
        case .email: return "No Teacher Email Available"
        case .total: return "Total Students Not Available"
        case .average: return "Average Grade Not Available"
        case .highest: return "Highest Grade Not Available"
        case .lowest: return "Lowest Grade Not Available"
        default: return ""
        }
    }
    
    func getSubtext(course: Course?) -> String? {
        switch self {
        case .courseName: return course?.name
        case .customName: return course?.custom_name
        case .period:
            if let period = course?.period {
                return String(format: "%d", period)
            } else { return nil }
        case .classroomNumber: return course?.classroom_number
        case .teacherName: return course?.teacher?.name
        case .email: return course?.teacher?.email
        case .total:
            if let total = course?.total_students {
                return String(format: "%d students", total)
            } else { return nil }
        case .average:
            if let average = course?.average_grade {
                return String(format: "%.2f%%", Double(exactly: average)!)
            } else { return nil }
        case .highest:
            if let highest = course?.highest_grade {
                return String(format: "%.2f%%", Double(exactly: highest)!)
            } else { return nil }
        case .lowest:
            if let lowest = course?.lowest_grade {
                return String(format: "%.2f%%", Double(exactly: lowest)!)
            } else { return nil }
        default: return nil
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .courseInfo: return #imageLiteral(resourceName: "grades")
        case .teacherInfo: return #imageLiteral(resourceName: "profile")
        case .statsInfo: return #imageLiteral(resourceName: "chart")
        default: return UIImage()
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .courseName, .customName, .period, .classroomNumber: return 0
        case .teacherName, .email: return 1
        case .total, .average, .highest, .lowest: return 2
        default: return 0
        }
    }
    
    func getCellType() -> String {
        switch self {
        default: return "InfoCell"
        }
    }
}
