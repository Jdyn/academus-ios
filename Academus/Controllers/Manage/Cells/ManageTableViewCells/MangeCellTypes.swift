//
//  CellType.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum MangeCellTypes{
    
    case mediumCell
    case smallCell
    
    func getHeight() -> CGFloat {
        switch self {
        case .smallCell: return 45
        case .mediumCell: return 55
        }
    }
    
    func getClass() -> BaseCell.Type{
        switch self {
        case .smallCell: return SmallCell.self
        case .mediumCell: return MediumCell.self
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .smallCell: return 1
        case .mediumCell: return 0
        }
    }
    
    func getRowCount() -> Int {
        switch self {
        case .smallCell: return 3
        case .mediumCell: return 2
        }
    }
}
