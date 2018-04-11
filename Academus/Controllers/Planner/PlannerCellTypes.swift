//
//  PlannerCellTypes.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

import UIKit

enum PlannerCellTypes {
    
    case plannerReminderCardCell
    case plannerNotepadCardCell
    
    func getHeight() -> CGFloat {
        switch self {
            
        case .plannerReminderCardCell: return 35
        case .plannerNotepadCardCell: return 150
        }
    }
    
    func getClass() -> PlannerMainCell.Type {
        switch self {
            
        case .plannerReminderCardCell: return PlannerReminderCardCell.self
        case .plannerNotepadCardCell: return PlannerNotePadCardCell.self
        }
    }
}
