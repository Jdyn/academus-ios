//
//  AssignmentDetailCell.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/25/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum AssignmentDetailCellManager {
    
    case title
    case score
    case dueDate
    case description
    
    func getTitle() -> String {
        switch self {
        case .title: return "Name"
        case .score: return "Score"
        case .dueDate: return "Due Date"
        case .description: return "Description"
        }
    }
    
    func getSubtext(assignment: Assignment?, card: PlannerCard?) -> String? {
        switch self {
        case .title: return assignment?.name ?? "Unknown Assignment"
        case .score: return assignment?.score?.text ?? card?.newScore?.scoreText ?? "No score available"
        case .dueDate:
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM d, yyyy"
                return formatter.string(from: assignment?.assigned_date ?? card?.newScore?.loggedAt ?? Date())
        case .description:
            guard assignment?.description != "" else { return "No Desription Available" }
            return assignment?.description
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        default: return UIImage()
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .description: return 1
        default: return 0
        }
    }
    
    func getCellType() -> String {
        switch self {
        case .title: return "nameCell"
        case .description: return "descriptionCell"
        default: return "infoCell"
        }
    }
}

