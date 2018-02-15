//
//  CourseModel.swift
//  Academus
//
//  Created by Jaden Moore on 2/14/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct CourseModel : Decodable {
    let success : Bool!
    let result : [CourseResult]
}

struct CourseResult : Decodable {
    let id : Int!
    let name : String!
    let period : Int!
    let custom_name : String!
    let integration : CourseIntegration
    let grade : CourseGrade
}

struct CourseIntegration : Decodable {
    let id : Int!
    let type : String!
    let name : String!
}

struct CourseGrade : Decodable {
    let letter : String!
    let percent : Float!
}


struct Course {
    let courseID : Int!
    let courseName : String!
    let courseGradeLetter : String!
    let courseGradePercent : Float!
    let coursePeriod : String!
}

