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
    func didGetIntegration(integrations: [Integration])
}

class IntegrationService {

    var delegate : IntegrationServiceDelegate?
    var route: String?
    
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
    
    
    URL(string: "\(BASE_URL)/api/integrations\(route!)?token=\(authToken)")!
    
    
    func addIntegration(districtCode: String?, username: String, password: String, completion: @escaping CompletionHandler) {
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_ACCOUNT)
        let authToken = dictionary?["authToken"] as! String
        
        let body: Parameters = [
            "beta_code": betaCode,
            "user": [
                "first_name": firstName,
                "last_name": lastName,
                "email": lowerCaseEmail,
                "password": password,
            ]
        ]
        
        Alamofire.request(URL_REGISTER!, method: .post, parameters: body, encoding: JSONEncoding.default).responseString { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data)
                    let success = json["success"].boolValue
                    if (success) {
                        print(json["result"])
                        let token = json["result"]["token"].stringValue
                        //                        let firstName = json["result"]["first_name"].stringValue
                        //                        let lastName = json["result"]["last_name"].stringValue
                        try Locksmith.updateData(data: [
                            "authToken" : token,
                            ], forUserAccount: USER_ACCOUNT)
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch let error {
                    debugPrint(error)
                }
            } else {
                debugPrint(response.result.error!)
            }
        }
    }
}

