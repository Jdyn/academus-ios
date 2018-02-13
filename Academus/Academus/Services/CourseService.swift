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
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                if let json = try! JSON(data: data).array {
                    for eachItem in json {
                        print(eachItem)
                    }
                }
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
//                        for item in json {
//
//                            let courseID = item["result"]["id"].intValue
//                            let courseName = item["name"].stringValue
//                            let coursePeriod = item["period"].stringValue
//                            let courseCustomName = item["custom_name"].stringValue
//
//                            let courseIntegrationID = item["integration"]["percent"].stringValue
//                            let courseIntegrationType = item["integration"]["type"].stringValue
//                            let courseIntegrationName = item["integration"]["name"].stringValue
//
//                            let courseGradeLetter = item["grade"]["letter"].stringValue
//                            let courseGradePercent = item["grade"]["percent"].stringValue
//
//                            let course = Course(courseID: courseID, courseName: courseName, coursePeriod: coursePeriod, custom_name: courseCustomName, courseIntegrationID: courseIntegrationID, courseIntegrationType: courseIntegrationType, courseIntegrationName: courseIntegrationName, courseGradeLetter: courseGradeLetter, courseGradePercent: courseGradePercent)
//                            print(courseID)
//                            //self.courses.append(course)
//                        }
                    //print(self.courses)
//                } else {
//                    completion(false)
//                    debugPrint(response.result.error)
//                }
                
                
                
                
                
                
//                guard let data = response.data else {return}
//                if response.result.error == nil {
//                    do {
//                        let courses = try JSONDecoder().decode(Courses.self, from: data)
//                        print(courses.result[3].name)
//
//
//                    } catch let error {
//                        debugPrint(error)
//                    }
//                completion(true)
//                } else {
//                    completion(false)
//                }
        }
    }

