//
//  AssignmentService.swift
//  Academus
//
//  Created by Jaden Moore on 2/12/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

class assignmentService {
    
    static let instance = assignmentService()
    
    
//    func getAssignments(completion: @escaping CompletetionHandler) {
//        Alamofire.request(URL_COURSE!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
//            
//            guard let data = response.data else {return}
//            if response.result.error == nil {
//                do {
//                    print("CourseService: Fetching Data")
//                    let courses = try JSONDecoder().decode(Courses.self, from: data)
//                    
//                    for eachCourse in courses.result {
//                        let name = eachCourse.name
//                        let letter = eachCourse.grade.letter
//                        let grade = eachCourse.grade.percent
//                        let period = String(eachCourse.period)
//                        
//                        let courses = MainCourses(courseName: name, courseLetter: letter, coursePercent: grade, coursePeriod: period)
//                        self.mainCourses.append(courses)
//                        
//                    }
//                } catch let error {
//                    debugPrint(error)
//                }
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
//    }
}
