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
    
    case coursePlannerCard
    
    func getTitle() -> String {
        switch self {
        case .coursePlannerCard: return "Course Update"
//        default: return ""
        }
    }
    
    func getCreatedTime(time: UpdatedCourses) -> Date {
        switch self {
        case .coursePlannerCard:
            
            return Date()
            
//        default: return Date()
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .coursePlannerCard: return 0
//        default: return 0
        }
    }
    
    func getHeight() -> CGFloat {
        switch self {
        case .coursePlannerCard: return 105
//        default: return 0
        }
    }
    
    func getType() -> String {
        switch self {
        case .coursePlannerCard: return "coursePlannerCard"
//        default: return ""
        }
    }
}
