//
//  PlannerModel.swift
//  Academus
//
//  Created by Jaden Moore on 4/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation


struct UpdatedCourses: Decodable {
    let course: Course?
    let currentGrade: GradeDataPoint?
    let previousGrade: GradeDataPoint?
    struct GradeDataPoint: Decodable {
        let gradeLetter: String?
        let gradePercent: Float?
        let loggedAt: Date?
    }
}
