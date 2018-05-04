//
//  StatusService.swift
//  Academus
//
//  Created by Jaden Moore on 5/3/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith

protocol getStatusDelegate {
    func didGetStatus(components: [ComponentModel])
}

class StatusService {
    
    var statusDelegate: getStatusDelegate?
    
    func getStatus(completion: @escaping CompletionHandler) {
        
        Alamofire.request(URL_COMPONENTS!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                
                do {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let json = JSON(data)
                    let jsonResult = try json["data"].rawData()
                    let components = try decoder.decode([ComponentModel].self, from: jsonResult)
                    self.statusDelegate?.didGetStatus(components: components)
                    completion(true)
                } catch let error {
                    completion(false)
                    print(error)
                }
            }
        }
    }
}
