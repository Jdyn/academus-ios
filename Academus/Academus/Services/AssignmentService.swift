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
    var mainUpcomingAssignments = [MainUpcomingAssignments]()
    var mainOtherAssignments = [MainOtherAssignments]()
    
    func getUpcomingAssignmentsForCourse(courseId: Int) -> [MainUpcomingAssignments] {
        return mainUpcomingAssignments.filter { $0.UpcomingAssignmentCourseID == courseId }
    }
    
    func getOtherAssignmentsForCourse(courseId: Int) -> [MainOtherAssignments] {
        return mainOtherAssignments.filter { $0.otherAssignmentCourse == courseId }
    }
    
    func getAssignments(completion: @escaping CompletetionHandler) {
        Alamofire.request(URL_ASSIGNMENT!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    print("AssignmentService: Fetching Data")
                    let assignments = try JSONDecoder().decode(Assignments.self, from: data)
                    
                    for eachAssignment in assignments.result.others {
                        let otherAssignmentName = eachAssignment.name
                        let otherAssignmentGrade = eachAssignment.score.text
                        let otherAssignmentCourseID = eachAssignment.course.id

                        
                        let assignment = MainOtherAssignments(otherAssignmentName: otherAssignmentName, otherAssignmentGrade: otherAssignmentGrade, otherAssignmentCourse: otherAssignmentCourseID)
                        
                        self.mainOtherAssignments.append(assignment)
                    }

                    for eachAssignment in assignments.result.upcoming {
                        let upcomingAssignmentName = eachAssignment.name
                        let upcomingAssignmentGrade = eachAssignment.score.text
                        let upcomingAssignmentCourseID = eachAssignment.course.id
                        
                        let assignment = MainUpcomingAssignments(UpcomingAssignmentName: upcomingAssignmentName, UpcomingAssignmentGrade: upcomingAssignmentGrade, UpcomingAssignmentCourseID: upcomingAssignmentCourseID)
                        
                        self.mainUpcomingAssignments.append(assignment)
                    }
                    
                } catch let error {
                    debugPrint(error)
                }
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
