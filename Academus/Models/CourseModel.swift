//
//  CourseModel.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/21/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

struct CourseModel: Decodable {
    let success : Bool
    let result : [Course]
}

struct Course : Decodable {
    let id : Int?
    let name : String?
    let period : Int?
    let custom_name : String?
    let integration : Integration?
    let grade : CourseGrade?
    struct Integration : Decodable {
        let id : Int?
        let type : String?
        let name : String?
    }
    struct CourseGrade : Decodable {
        let letter : String?
        let percent : Float?
    }
}
