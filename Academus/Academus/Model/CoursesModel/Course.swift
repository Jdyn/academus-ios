//
//  Course.swift
//  Academus
//
//  Created by Jaden Moore on 2/11/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct Course: Decodable {
    let id : Int
    let name : String
    let period : Int
    let custom_name : String!
    
    let integration : CourseIntegration
    let grade : CourseGrade
}
