//
//  SettingsCellTypes.swift
//  Academus
//
//  Created by Jaden Moore on 3/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum CellTypes {
    
    case manageSmallCell
    case manageMediumCell
    
    case settingsSmallCell
    case settingsMediumCell
    
    case helpStandardCell
    
    func getHeight() -> CGFloat {
        switch self {
        case .manageSmallCell, .settingsSmallCell: return 45
        case .manageMediumCell, .settingsMediumCell, .helpStandardCell: return 55
        }
    }
    
    func getClass() -> MainCell.Type{
        switch self {
        case .manageSmallCell: return ManageSmallCell.self
        case .manageMediumCell: return ManageMediumCell.self
            
        case .settingsSmallCell: return SettingsSmallCell.self
        case .settingsMediumCell: return SettingsMediumCell.self
            
        case .helpStandardCell: return ManageHelpCell.self
        }
    }
}
