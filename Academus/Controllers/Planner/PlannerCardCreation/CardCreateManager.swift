//
//  CardCreateManager.swift
//  Academus
//
//  Created by Jaden Moore on 4/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum CardCreateManager {
    
    case input
    case inputLong
    case button
    case picker
    
    func getHeight() -> CGFloat {
        switch self {
        case .input: return 80
        case .inputLong: return 115
        case .button: return 45
        case .picker: return 200
        }
    }
    
    func getClass() -> PlannerMainCell.Type {
        switch self {
        case .input: return InputCell.self
        case .inputLong: return InputLongCell.self
        case .button: return ButtonCell.self
        case .picker: return PickerCell.self
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
