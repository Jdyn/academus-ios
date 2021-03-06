//
//  AssignmentService.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith

protocol AssignmentServiceDelegate {
    func didGetAssignments(assignments: [Assignment])
}

class AssignmentService {
    
    var delegate : AssignmentServiceDelegate?
    
    func getAssignments(courseID: Int, completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        let authToken = dictionary?["authToken"] as! String
        Alamofire.request(URL(string: "\(BASE_URL)/api/courses/\(courseID)/assignments?token=\(authToken)")!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let json = JSON(data)
                    let jsonResult = try json["result"].rawData()
                    let assignment = try decoder.decode([Assignment].self, from: jsonResult)
                    if json["success"] == true {
                        self.delegate?.didGetAssignments(assignments: assignment)
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

