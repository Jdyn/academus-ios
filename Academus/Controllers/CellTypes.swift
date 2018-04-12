//
//  SettingsCellTypes.swift
//  Academus
//
//  Created by Jaden Moore on 3/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum CellTypes {

    case smallCell
    case mediumCell

    func getClass() -> UITableViewCell.Type {
        switch self {
        case .smallCell: return SmallCell.self
        case .mediumCell: return MediumCell.self
        }
    }
}

class SmallCell: UITableViewCell {}
class MediumCell: UITableViewCell {}
