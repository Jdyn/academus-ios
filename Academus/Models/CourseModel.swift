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
    let custom_name : String?
    let period : Int?
    let classroom_number : String?
    let integration : Integration?
    let grade : Grade?
    let teacher : Teacher?
    struct Integration : Decodable {
        let id : Int?
        let type : String?
        let name : String?
    }
    struct Grade : Decodable {
        let letter : String?
        let percent : Float?
    }
    struct Teacher : Decodable {
        let name : String?
        let email : String?
    }
    let total_students : Int?
    let average_grade : Float?
    let highest_grade : Float?
    let lowest_grade : Float?
    let categories: [Category]?
    struct Category: Decodable {
        let id: Int?
        let name: String?
        let weight: String?
        let points: String?
        let pointsPossible: String?
        let weightedPercent: String?
        let weightedGradeLetter: String?
        
        func weightAsDouble() -> Double {
            if let weight = self.weight, let index = self.weight?.range(of: "%", options: .backwards)?.lowerBound {
                return Double(weight[..<index]) ?? Double(0)
            } else { return Double(0) }
        }
        
        func truncatedName() -> String? {
            if let name = self.name {
                let truncName = name.prefix(20)
                if truncName.elementsEqual(name) {
                    return name
                } else {
                    return String(truncName) + "..."
                }
            } else { return nil }
        }
    }
}
