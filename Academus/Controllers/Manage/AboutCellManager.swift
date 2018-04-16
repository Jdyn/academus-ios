//
//  AboutCellManager.swift
//  Academus
//
//  Created by Jaden Moore on 3/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

enum AboutCellManager {
    
    case alamofire
    case swiftyJson
    case locksmith
    case libraries
    
    func getTitle() -> String{
        switch self {
        case .alamofire: return "Alamofire"
        case .swiftyJson: return "SwiftyJSON"
        case .locksmith: return "Locksmith"
        case .libraries: return "Libraries"
        }
    }
    
    func getSubtext() -> String{
        switch self {
        case .alamofire: return "Alamofire is an HTTP networking library written in Swift."
        case .swiftyJson: return "SwiftyJSON makes it easy to deal with JSON data in Swift."
        case .locksmith: return "A powerful, protocol-oriented library for working with the keychain in Swift."
        default: return ""
        }
    }
    
    func getLink() -> String {
        switch self {
        case .alamofire: return "https://github.com/Alamofire/Alamofire"
        case .swiftyJson: return "https://github.com/SwiftyJSON/SwiftyJSON"
        case .locksmith: return "https://github.com/matthewpalmer/Locksmith"
        default: return ""
        }
    }
    
    func getHeight() -> CGFloat {
        switch self {
        default: return 80
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .alamofire, .swiftyJson, .locksmith: return 0
        default: return 0
        }
    }
    
    func getCellType() -> String{
        switch self {
        default: return "AboutCell"
        }
    }
}
