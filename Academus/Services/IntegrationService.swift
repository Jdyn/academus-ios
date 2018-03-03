//
//  IntegrationService.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

import Foundation
import SwiftyJSON
import Alamofire

protocol IntegrationServiceDelegate {
    func didGetIntegration(integrations: [Integration])
}

class IntegrationService {

    var delegate : IntegrationServiceDelegate?
    
    func getIntegrations(completion: @escaping CompletionHandler) {

        Alamofire.request(URL_GET_INTEGRATION!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            (response) in

            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    let json = try JSON(data: data)
                    let jsonResult = try json["result"].rawData()
                    
                    let integrations = try JSONDecoder().decode([Integration].self, from: jsonResult)
                    if json["success"] == true {
                        print("integration success")
                        self.delegate?.didGetIntegration(integrations: integrations)
                        completion(true)
                    }
                } catch let error {
                    completion(false)
                    debugPrint(error)
                }
            }
        }
    }
}

