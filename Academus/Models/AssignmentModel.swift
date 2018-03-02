//
//  AssignmentModel.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct AssignmentModel : Decodable{
    let success : Bool
    let result : [Assignment]
}

struct Assignment : Decodable{
    let id : Int?
    let name : String?
    let description : String?
    let course : AssignmentCourse
    struct AssignmentCourse : Decodable {
        let id : Int?
        let name : String?
        let custom_name : String?
    }
    let assigned_date : Date?
    let due_date : Date?
    let is_late : String?
    let late_reason : String?
    let score : AssignmentScore
    struct AssignmentScore : Decodable {
        let text : String?
        let percent : String?
    }
}
