//
//  ApiService.swift
//  Academus
//
//  Created by Jaden Moore on 6/10/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ApiService {
    
    func fetchGenericData<T: Decodable>(url: String,
                                        dateFormat: String? = "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                        completion: @escaping (T?, _ success: Bool, _ error: String?) -> ()) {
        
        Alamofire.request(URL(string: url)!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = JSON(data)
                let success = json["success"].boolValue
                
                if success {
                    do {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = dateFormat
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)

                        let result = try json["result"].rawData()
                        let model = try decoder.decode(T.self, from: result)
                        
                        completion(model, true, nil)
                        
                    } catch let error {
                        print(error)
                        completion(nil, false, error.localizedDescription)
                    }
                } else {
                    completion(nil, false, json["error"].stringValue)
                }
            } else {
                completion(nil, false, response.result.error?.localizedDescription)
            }
        }
    }
}
