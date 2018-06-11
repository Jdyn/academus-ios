//
//  ApiManager.swift
//  Academus
//
//  Created by Jaden Moore on 6/9/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Locksmith

enum ApiManager {
    
    case planner
    case courses
    case assignments
    case statusAlert
    
    func getUrl(courseID: Int? = nil) -> String {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        let authToken = dictionary?[AUTH_TOKEN] as! String
        
        switch self {
        case .planner: return "\(BASE_URL)/api/feed?token=\(authToken)"
        case .courses: return "\(BASE_URL)/api/courses?token=\(authToken)"
        case .assignments: return "\(BASE_URL)/api/courses/\(courseID!)/assignments?token=\(authToken)"
        case .statusAlert: return "\(STATUS_URL)/api/v1/components"
        }
    }
    
}
