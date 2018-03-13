//
//  CellType.swift
//  Academus
//
//  Created by Jaden Moore on 3/12/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum CellType{
    
    case manageInvites
    case manageIntegrations
    case settings
    case help
    case about
    
    func getHeight() -> CGFloat{
        switch self {
        case .manageInvites, .manageIntegrations: return 70
        case .settings, .help, .about: return 55
        }
    }
    
    func getClass() -> BaseCell.Type{
        switch self {
        case .manageInvites: return manageInvitesCell.self
        case .manageIntegrations: return manageIntegrationsCell.self
        case .settings: return settingsCell.self
        case .help: return helpCell.self
        case .about: return aboutCell.self
        }
    }
    
}
