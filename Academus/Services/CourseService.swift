//
//  CourseService.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/21/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol CourseServiceDelegate {
    func didGetCourses(courses : CourseModel)
}

class CourseService {
    
    var delegate : CourseServiceDelegate?
    
    func getCourses(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_COURSE!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    let course = try JSONDecoder().decode(CourseModel.self, from: data)
                    if course.success == true {
                        self.delegate?.didGetCourses(courses: course)
                    } else {
                        return
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
