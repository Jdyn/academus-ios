//
//  IntegrationService.swift
//  Academus
//
//  Created by Jaden Moore on 2/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class IntegrationService {
    
    static let instance = IntegrationService()
    
    var integrations = [Integration]()
    
    func getIntegrations(completion: @escaping CompletetionHandler) {
        
        Alamofire.request(URL_GET_INTEGRATION!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    let integrations = try JSONDecoder().decode(IntegrationModel.self, from: data)
                    
                    for integration in integrations.result {
                        let integrationRoute = integration.route
                        let integrationnName = integration.name
                        let IntegrationIcon = integration.icon_url
                        
                        let integrations = Integration(integrationRoute: integrationRoute, integrationName: integrationnName, integrationIcon: IntegrationIcon)
                        self.integrations.append(integrations)
                    }
                } catch let error {
                    debugPrint(error)
                }
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}


