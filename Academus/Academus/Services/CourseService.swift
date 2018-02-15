//
//  CourseService.swift
//  Academus
//
//  Created by Jaden Moore on 2/11/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CourseService {
    
    static let instance = CourseService()
    
    var courses = [Course]()
    
    func getCourses(completion: @escaping CompletetionHandler) {
        
        Alamofire.request(URL_COURSE!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            
            if response.result.error == nil {
                do {
                    let courses = try JSONDecoder().decode(CourseModel.self, from: data)
                    
                    for course in courses.result {
                        let courseID = course.id
                        let courseName = course.name
                        let courseGradeLetter = course.grade.letter
                        let courseGradePercent = course.grade.percent
                        let coursePeriod = String(course.period)
                        
                        let course = Course(courseID: courseID, courseName: courseName, courseGradeLetter: courseGradeLetter, courseGradePercent: courseGradePercent, coursePeriod: coursePeriod)
                        self.courses.append(course)
                    }
                } catch let error{
                    print(error)
                }
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}
