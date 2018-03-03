//
//  CourseModel.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/21/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

struct Course : Decodable {
    let id : Int?
    let name : String?
    let period : Int?
    let custom_name : String?
    let integration : Integration?
    let grade : Grade?
    struct Integration : Decodable {
        let id : Int?
        let type : String?
        let name : String?
    }
    struct Grade : Decodable {
        let letter : String?
        let percent : Float?
    }
}
