//
//  ManageCellType.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum ManageCellManager {
    
    case manageIntegrations
    case manageInvites
    case settings
    case help
    case about
    
    func getTitle() -> String{
        switch self {
        case .manageIntegrations: return "Manage Integrations"
        case .manageInvites: return "Invite Friends"
        case .settings: return "Settings"
        case .help: return "Chat with Us"
        case .about: return "About"
        }
    }
    
    func getSubtext() -> String{
        switch self {
        case .manageIntegrations: return ""
        case .manageInvites: return ""
        case .settings: return ""
        case .help: return ""
        case .about: return ""
        }
    }
    
    func getImage() -> UIImage{
        switch self {
        case .manageIntegrations: return #imageLiteral(resourceName: "sync")
        case .manageInvites: return #imageLiteral(resourceName: "personAdd")
        case .settings: return #imageLiteral(resourceName: "settings")
        case .help: return #imageLiteral(resourceName: "help")
        case .about: return #imageLiteral(resourceName: "about")
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .manageIntegrations, .manageInvites: return 0
        case .settings, .help, .about: return 1
        }
    }
    
    func getHeight() -> CGFloat {
        switch self {
        case .manageIntegrations, .manageInvites: return 75
        case .settings, .help, .about: return 65
        }
    }
    
    func getCellType() -> String {
        switch self {
        case .manageIntegrations, .manageInvites: return "MediumCell"
        case .settings, .help, .about: return "SmallCell"
        }
    }
}
