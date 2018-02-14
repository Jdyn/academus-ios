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
    var mainIntegrations = [MainIntegrations]()
    
    func getIntegrations(completion: @escaping CompletetionHandler) {
        
        Alamofire.request(URL_GET_INTEGRATION!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                
                do {
                    let integrations = try JSONDecoder().decode(Integrations.self, from: data)
                    
                    for eachIntegration in integrations.result {
                        let route = eachIntegration.route
                        let name = eachIntegration.name
                        let iconUrl = eachIntegration.icon_url
                        
                        let mainIntegrations = MainIntegrations(IntegrationRoute: route, IntegrationName: name, IntegrationIcon: iconUrl)
                        
                        self.mainIntegrations.append(mainIntegrations)
                        
//                        for eachEntry in eachIntegration.fields {
//                            let username = eachEntry.id
//                            let password = eachEntry.label
//                            
//
//                        }
                    }
                } catch let error {
                    debugPrint(error)
                }
            } else {
                debugPrint(response.result.error!)
            }
            completion(true)
        }
    }
    
    func addIntegrations() {
        
        
    }
}


