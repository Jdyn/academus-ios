//
//  CellType.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum CellType{
    
    case mediumCell
    case smallCell
    case largeCell
    
    func getHeight() -> CGFloat {
        switch self {
        case .mediumCell: return 50
        case .smallCell: return 35
        case .largeCell: return 105
        }
    }
    
    func getClass() -> BaseCell.Type{
        switch self {
        case .mediumCell: return MediumCell.self
        case .smallCell: return SmallCell.self
        case .largeCell: return LargeCell.self
        }
    }
}
