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

class assignmentService {
    
    static let instance = assignmentService()
    
    
    func getAssignments(completion: @escaping CompletetionHandler) {
        Alamofire.request(URL_ASSIGNMENT!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    print("AssignmentService: Fetching Data")
                    let assignments = try JSONDecoder().decode(Assignments.self, from: data)
                    
                    for eachAssignment in assignments.result.others {
                        let otherName = eachAssignment.name
                    }

                    for eachAssignment in assignments.result.upcoming {
                        let upcomingName = eachAssignment.name
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
