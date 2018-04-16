//
//  CardCreateManager.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum CardCreateType {
    
    case input
    case inputLong
    case button
    case dropdown
    case picker
    
    func getHeight() -> CGFloat {
        switch self {
        case .input: return 80
        case .inputLong: return 115
        case .dropdown: return 80
        case .button: return 45
        case .picker: return 200
        }
    }
    
    func getClass() -> PlannerMainCell.Type {
        switch self {
        case .input: return InputCell.self
        case .inputLong: return InputLongCell.self
        case .dropdown: return DropdownCell.self
        case .button: return ButtonCell.self
        case .picker: return PickerCell.self
        }
    }
}

enum CardFormManager {
    
    // Reminder
    case reminderTitle
    case coloredPicker
    case presetTimes
    
    // Notepad
    case notepadTitle
    case notepadBody
    
    func placeholder() -> String{
        switch self {
        case .reminderTitle: return "Create a reminder"
        case .notepadTitle: return "Create a note title"
        case .notepadBody: return "Begin a note..."
        default: return ""
        }
    }
    
//    func image() -> String{
//        switch self {
//        case .reminderTitle:
//        case .notepadTitle:
//        default: return ""
//        }
//    }
    
    func keyboardSecure() -> Bool{
        switch self {
        default: return false
        }
    }
    
    func keyboardType() -> UIKeyboardType{
        switch self {
        default: return .default
        }
    }
    
    func pickerOptions()->[String]{
        switch self {
        case .presetTimes:
            return ["Morning", "Afternoon", "Evening"]
        default: return []
        }
    }
    
    func cellType() -> CardCreateType{
        switch self {
        case .reminderTitle, .notepadTitle: return .input
        case .notepadBody: return .inputLong
        case .coloredPicker: return .dropdown
        default: return .input
        }
    }
}

class InputCell: PlannerMainCell, UITextFieldDelegate {
    
    let field = UITextField()
    
    
}

class InputLongCell: PlannerMainCell {
    
}

class ButtonCell: PlannerMainCell {
    
}

class PickerCell: PlannerMainCell {
    
}

class DropdownCell: PlannerMainCell {
    
}
