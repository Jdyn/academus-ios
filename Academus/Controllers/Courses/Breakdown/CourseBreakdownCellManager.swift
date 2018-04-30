//
//  CourseBreakdownCellManager.swift
//  Academus
//
//  Created by Jaden Moore on 4/29/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation


import UIKit

enum CourseBreakdownCellManager {
    
    case title
    case total
    case points
    case chart
    
    func getTitle() -> String {
        switch self {
        default: return ""
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        default: return UIImage()
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .points: return 1
        case .chart: return 2
        default: return 0
        }
    }
    
    func getCellType() -> String {
        switch self {
        case .title: return "titleCell"
        case .points: return "pointsCell"
        case .total: return "totalCell"
        case .chart: return "chartCell"
        }
    }
}
