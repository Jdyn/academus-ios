//
//  ManageCellType.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

enum FormCellType {
    
    case profile
    case manageIntegrations
    case manageInvites
    case settings
    case help
    case about
    
    func getTitle() -> String{
        let dictionary: Dictionary? = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        
        switch self {
        case .profile: return "\(dictionary?["firstName"] ?? "Unkown") \(dictionary?["lastName"] ?? "Name")"
        case .manageIntegrations: return "Manage Integrations"
        case .manageInvites: return "Manage Invites"
        case .settings: return "Settings"
        case .help: return "Help"
        case .about: return "About Us"
        }
    }
    
    func getSubtext() -> String{
        let dictionary: Dictionary? = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        
        switch self {
        case .profile: return "\(dictionary?["email"] ?? "Unknown Email")"
        case .manageIntegrations: return ""
        case .manageInvites: return ""
        case .settings: return ""
        case .help: return ""
        case .about: return ""
        }
    }
    
    func image() -> UIImage{
        switch self {
        case .profile: return #imageLiteral(resourceName: "profile")
        case .manageIntegrations: return #imageLiteral(resourceName: "sync")
        case .manageInvites: return #imageLiteral(resourceName: "personAdd")
        case .settings: return #imageLiteral(resourceName: "settings")
        case .help: return #imageLiteral(resourceName: "help")
        case .about: return #imageLiteral(resourceName: "about")
        }
    }
    
    func cellType() -> CellType{
        switch self {
        case .profile: return .largeCell
        case .manageIntegrations, .manageInvites: return .mediumCell
        case .settings, .help, .about: return .smallCell
        }
    }
}
