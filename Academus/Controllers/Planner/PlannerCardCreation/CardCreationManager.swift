//
//  CardCreationManager.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum CardCreationManager {
    
    case cards
        
    case reminderCard
    case notepadCard
    
    case standardTitle
    case standardTextbox
    case dropdownMenu
    case datePicker
    
    func getTitle() -> String {
        switch self {
        case .reminderCard: return "Reminder"
        case .notepadCard: return "Notepad"
        case .cards: return "Select a card"
        default: return ""
        }
    }
    
    func getGhostText() -> String{
        switch self {
        case .standardTitle: return "Create a title (Optional)"
        case .standardTextbox: return "Add some text"
        default: return ""
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .reminderCard, .notepadCard: return 0
        case .standardTitle, .standardTextbox, .dropdownMenu, .datePicker: return 1
        default: return 0
        }
    }
    
    func getHeight() -> CGFloat {
        switch self {
        case .reminderCard, .notepadCard: return 40
        case .standardTitle: return 35
        case .standardTextbox: return 150
        case .dropdownMenu: return 80
        case .datePicker: return 200
        default: return 0
        }
    }
    
    func getType() -> String {
        switch self {
        case .reminderCard, .notepadCard: return "CardButton"
        case .standardTitle: return "StandardInput"
        case .standardTextbox: return "StandardTextbox"
        case .dropdownMenu: return "DropdownMenu"
        case .datePicker: return "DatePicker"
        default: return ""
        }
    }
}
