//
//  AssignmentEntry.swift
//  Academus
//
//  Created by Jaden Moore on 2/12/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct AssignmentEntry : Decodable {
    
    let id : Int
    let name : String
    let description : String!
    let course : [AssignmentCourse]
    let assigned_date : String
    let due_date : String!
    let is_late : String!
    let late_reason : String!
    let score : [AssignmentScore]
    
    
}
