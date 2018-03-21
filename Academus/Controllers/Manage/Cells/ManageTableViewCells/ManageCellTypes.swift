//
//  CellType.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum ManageCellTypes{
    
    case smallCell
    case mediumCell
    
    func getHeight() -> CGFloat {
        switch self {
        case .smallCell: return 45
        case .mediumCell: return 55
        }
    }
    
    func getClass() -> ManageBaseCell.Type{
        switch self {
        case .smallCell: return ManageSmallCell.self
        case .mediumCell: return ManageMediumCell.self
        }
    }
}
