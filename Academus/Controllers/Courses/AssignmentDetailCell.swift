//
//  AssignmentDetailCell.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/25/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum AssignmentDetailCellManager {
    case header
    case name
    case course
    case score
    case dueDate
    case description
    
    func getTitle() -> String {
        switch self {
        case .header: return "Assignment Details"
        case .name: return "Name"
        case .course: return "Course"
        case .score: return "Score"
        case .dueDate: return "Due Date"
        case .description: return "Description"
        }
    }
    
    func getAltSubtext() -> String {
        switch self {
        case .description: return "No Description Available"
        default: return ""
        }
    }
    
    func getSubtext(assignment: Assignment?) -> String? {
        switch self {
        case .name: return assignment?.name
        case .course: return assignment?.course?.name
        case .score: return assignment?.score?.text
        case .dueDate:
            if let date = assignment?.assigned_date {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM d, yyyy"
                return formatter.string(from: date)
            } else { return nil }
        case .description: return assignment?.description
        default: return nil
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .header: return #imageLiteral(resourceName: "courseNotif")
        default: return UIImage()
        }
    }
    
    func getSection() -> Int {
        return 0
    }
    
    func getCellType() -> String {
        return "AssDetailCell"
    }
}

