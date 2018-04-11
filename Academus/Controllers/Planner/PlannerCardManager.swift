//
//  PlannerCardManager.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum PlannerCardManager {
    
    case reminderCard
    case notepadCard
    
    func cardTypeTitle() -> String {
        switch self {
        case .reminderCard: return "Reminder"
        case .notepadCard: return "NotePad"
        }
    }
    
    func getCardCreatedDate() -> Date {
        switch self {
        case .reminderCard, .notepadCard: return Date()
        }
    }
    
    func cellType() -> PlannerCellTypes {
        switch self {
        case .reminderCard: return .plannerReminderCardCell
        case .notepadCard: return .plannerNotepadCardCell
        }
    }
}

class PlannerReminderCardCell: PlannerMainCell {
    
}

class PlannerNotePadCardCell: PlannerMainCell {
    
}
