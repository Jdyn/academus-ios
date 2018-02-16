//
//  AssignmentService.swift
//  Academus
//
//  Created by Jaden Moore on 2/12/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class AssignmentService {

    static let instance = AssignmentService()
    
    var assignments = [Assignment]()

    func getAssignments(completion: @escaping CompletetionHandler) {

        Alamofire.request(URL_ASSIGNMENT!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in

            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    let assignments = try JSONDecoder().decode(AssignmentModel.self, from: data)

                    for assignment in assignments.result {
                        let assignmentName = assignment.name
                        let assignmentGrade = assignment.score.text
                        let assignmentCourseID = assignment.course.id

                        let assignment = Assignment(assignmentName: assignmentName, assignmentGrade: assignmentGrade, assignmentCourseID: assignmentCourseID)

                        self.assignments.append(assignment)
                    }
                } catch let error {
                    debugPrint(error)
                }
                completion(true)
            } else {
                print(response.result.error!)
                completion(false)
            }
        }
    }

    func getAssignmentsForCourse(courseID: Int) -> [Assignment] {
        return assignments.filter { $0.assignmentCourseID == courseID }
    }
}


