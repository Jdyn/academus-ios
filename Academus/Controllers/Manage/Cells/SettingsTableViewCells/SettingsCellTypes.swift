//
//  SettingsCellTypes.swift
//  Academus
//
//  Created by Jaden Moore on 3/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum SettingsCellTypes{
    
    case mediumCell
    case smallCell
    
    func getHeight() -> CGFloat {
        switch self {
        case .smallCell: return 45
        case .mediumCell: return 55
        }
    }
    
    func getClass() -> SettingsBaseCell.Type{
        switch self {
        case .smallCell: return SettingsSmallCell.self
        case .mediumCell: return SettingsMediumCell.self
        }
    }
}
