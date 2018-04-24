//
//  PlannerCellManager.swift
//  Academus
//
//  Created by Jaden Moore on 4/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
//
//  CardCreationManager.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum PlannerCellManager {
    
    case courseUpdatedCard
    case assignmentPostedCard
    case assignmentUpdatedCard
    case upcomingAssignmentCard
    
    func getTitle() -> String {
        switch self {
        case .courseUpdatedCard: return "Course Grade Update"
        case .assignmentPostedCard: return "Assignment Posted"
        case .assignmentUpdatedCard: return "Assignment Grade Update"
        case .upcomingAssignmentCard: return "Upcoming Assignment"
        }
    }
    
    func getSection() -> Int {
        switch self {
        default: return 0
        }
    }
    
    func getColor() -> UIColor {
        switch self {
        case .courseUpdatedCard: return UIColor.navigationsBlue
        case .assignmentPostedCard: return UIColor.navigationsOrange
        case .assignmentUpdatedCard: return UIColor.navigationsPurple
        case .upcomingAssignmentCard: return UIColor.navigationsRed
        }
    }
    
    func getType() -> String {
        switch self {
        case .courseUpdatedCard: return "coursePlannerCard"
        case .assignmentPostedCard: return "assignmentPostedCard"
        case .assignmentUpdatedCard: return "assignmentUpdatedCard"
        case .upcomingAssignmentCard: return "upcomingAssignmentCard"
        }
    }
}
