//
//  AssignmentModel.swift
//  Academus
//
//  Created by Jaden Moore on 2/14/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct AssignmentModel : Decodable {
    let success : Bool!
    let result : [AssignmentResult]
}

struct AssignmentResult : Decodable {
    let id : Int!
    let name : String!
    let description : String!
    let course : AssignmentCourse
    let assigned_date : String!
    let due_date : String!
    let is_late : String!
    let late_reason : String!
    let score : AssignmentScore
}

struct AssignmentCourse : Decodable {
    let id : Int!
    let name : String!
    let custom_name : String!
}

struct AssignmentScore : Decodable {
    let text : String!
    let percent : String!
}

struct Assignment {
    let assignmentName : String!
    let assignmentGrade : String!
    let assignmentCourseID : Int!
}
