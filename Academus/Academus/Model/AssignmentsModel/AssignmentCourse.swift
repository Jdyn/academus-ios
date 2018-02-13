//
//  AssignmentCourse.swift
//  Academus
//
//  Created by Jaden Moore on 2/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct AssignmentCourse : Decodable {
    
    let id : Int
    let name : String
    let custom_name : String!
}
