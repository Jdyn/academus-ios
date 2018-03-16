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
        case .smallCell: return 45
        case .mediumCell: return 55
<<<<<<< HEAD
        case .largeCell: return 65
=======
        case .largeCell: return 105
>>>>>>> d321d897c6b5f1da3a9c180d1a961186bc97cf20
        }
    }
    
    func getClass() -> BaseCell.Type{
        switch self {
        case .smallCell: return SmallCell.self
        case .mediumCell: return MediumCell.self
        case .largeCell: return LargeCell.self
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .smallCell: return 2
        case .mediumCell: return 1
        case .largeCell: return 0
        }
    }
    
    func getRowCount() -> Int {
        switch self {
        case .smallCell: return 3
        case .mediumCell: return 2
        case .largeCell: return 1
        }
    }
}
