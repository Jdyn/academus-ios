//
//  PlannerModel.swift
//  Academus
//
//  Created by Jaden Moore on 4/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct PlannerCard: Decodable {
    let type: String?
    let date: Date?
    let affectingAssignments: [AffectingAssignment]?
    let newGrade: GradeDataPoint?
    let previousGrade: GradeDataPoint?
    let assignment: Assignment?
    let course: Course?
    let newScore: ScoreDataPoint?
    let previousScore: ScoreDataPoint?
    struct AffectingAssignment: Decodable {
        let id: Int?
        let name: String?
        let score: Score?
        struct Score: Decodable {
            let text: String?
            let percent: Float?
        }
    }
    struct GradeDataPoint: Decodable {
        let gradeLetter: String?
        let gradePercent: Double?
        let loggedAt: Date?
    }
    struct ScoreDataPoint: Decodable {
        let scoreText: String?
        let scorePercent: Double?
        let loggedAt: Date?
    }
}



//    struct Course: Decodable {
//        let id: String?
//        let name: String?
//        let customName: String?
//    }


//struct Assignment: Decodable {
//    let id: Int?
//    let name: String?
//    let description: String?
//    let score: Score?
//    let course: Course
//    let assigned_date: Date?
//    let due_date: Date?
//    let is_late: String?
//    let late_reason: String?
//    struct Score: Decodable {
//        let text: String?
//        let percent: Double?
//    }
//}
