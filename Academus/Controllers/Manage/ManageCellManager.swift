//
//  ManageCellType.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum ManageCellManager {
    
    case header1
    case header2
    
    case manageIntegrations
    case inviteFriends
    case settings
    case help
    case about
    
    func getTitle() -> String{
        switch self {
        case .manageIntegrations: return "Manage Integrations"
        case .inviteFriends: return "Invite Friends"
        case .settings: return "Settings"
        case .help: return "Chat with Us"
        case .about: return "About"
        default: return ""
        }
    }
    
    func getSubtext() -> String{
        switch self {
        case .manageIntegrations: return ""
        case .inviteFriends: return ""
        case .settings: return ""
        case .help: return ""
        case .about: return ""
        default: return ""
        }
    }
    
    func getImage() -> UIImage{
        switch self {
        case .manageIntegrations: return #imageLiteral(resourceName: "sync")
        case .inviteFriends: return #imageLiteral(resourceName: "personAdd")
        case .settings: return #imageLiteral(resourceName: "settings")
        case .help: return #imageLiteral(resourceName: "help")
        case .about: return #imageLiteral(resourceName: "about")
        default: return UIImage()
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .manageIntegrations, .inviteFriends: return 0
        case .settings, .help, .about: return 1
        case .header1: return 1
        case .header2: return 2
        }
    }
    
    func getHeight() -> CGFloat {
        switch self {
        case .manageIntegrations, .inviteFriends: return 65
        case .settings, .help, .about: return 55
        default: return 9
        }
    }
    
    func getCellType() -> String {
        switch self {
        case .manageIntegrations, .inviteFriends: return "MediumCell"
        case .settings, .help, .about: return "SmallCell"
        default: return "headerCell"
        }
    }
}
