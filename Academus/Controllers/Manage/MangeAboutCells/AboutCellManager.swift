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
    
    func getTitle() -> String{
        switch self {
        case .alamofire: return "Alamofire"
        case .swiftyJson: return "SwiftyJSON"
        case .locksmith: return "Locksmith"
        }
    }
    
    func getSubtext() -> String{
        switch self {
        case .alamofire: return "Alamofire is an HTTP networking library written in Swift."
        case .swiftyJson: return "SwiftyJSON makes it easy to deal with JSON data in Swift."
        case .locksmith: return "yes"//"A powerful, protocol-oriented library for working with the keychain in Swift."
        }
    }
    
    func getSection() -> Int {
        switch self {
        case .alamofire, .swiftyJson, .locksmith: return 0
        }
    }
    
    func rowCount() -> Int {
        switch self {
        case .alamofire, .swiftyJson, .locksmith: return 3
        }
    }
    
    func cellType() -> CellTypes{
        switch self {
        case .alamofire, .swiftyJson, .locksmith: return .aboutStandardCell
        }
    }
}
