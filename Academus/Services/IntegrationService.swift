//
//  IntegrationService.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import Locksmith

protocol IntegrationServiceDelegate {
    func didGetIntegration(integrations: [IntegrationChoice])
}

class IntegrationService {

    var delegate : IntegrationServiceDelegate?
    var integration: IntegrationChoice?

    func getIntegrations(completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        let authToken = dictionary?["authToken"] as! String
        Alamofire.request(URL(string: "\(BASE_URL)/api/integrations/available?token=\(authToken)")!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            (response) in

            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    let json = try JSON(data: data)
                    let jsonResult = try json["result"].rawData()
                    let integrations = try JSONDecoder().decode([IntegrationChoice].self, from: jsonResult)
                    
                    if json["success"] == true {
                        self.delegate?.didGetIntegration(integrations: integrations)
                        completion(true)
                    }
                } catch let error {
                    completion(false)
                    debugPrint(error)
                }
            } else {
                completion(false)
            }
        }
    }
    
    
    func addIntegration(fields: [UITextField], completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        let authToken = dictionary?["authToken"] as! String
        let route = integration?.route ?? ""
        let body: Parameters = ["string":"String"]
        for i in 0...fields.count {
            
        }


        
        Alamofire.request(URL(string: "\(BASE_URL)/api/integrations/\(route)?token=\(authToken)")!, method: .post, parameters: body, encoding: JSONEncoding.default).responseString { (response) in
        
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data)
                    let success = json["success"].boolValue
                    if (success) {
                        print(json["result"])
                        completion(true)
                    } else {
                        print("adding failed")
                        completion(false)
                    }
                } catch let error {
                    completion(false)
                    debugPrint(error)
                }
            } else {
                completion(false)
                debugPrint(response.result.error!)
            }
        }
    }
}

