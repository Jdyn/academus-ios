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
import Locksmith

protocol CourseServiceDelegate {
    func didGetCourses(courses : [Course])
}

class CourseService {
    
    var delegate : CourseServiceDelegate?
    
    func getCourses(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_COURSE!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    let json = try JSON(data: data)
                    let jsonResult = try json["result"].rawData()
                    let course = try JSONDecoder().decode([Course].self, from: jsonResult)
                    if json["success"] == true {
                        self.delegate?.didGetCourses(courses: course)
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
