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
    var body: Parameters?
    
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
    
    
    func addIntegration(districtCode: String?, username: String, password: String, completion: @escaping CompletionHandler) {
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        let authToken = dictionary?["authToken"] as! String
        
        if route == "studentvue" {
            self.body = [
                "username": username,
                "password": password,
        ]
            
        } else if route == "powerschool" {
            self.body = [
                "district_code": districtCode!,
                "username": username,
                "password": password,
            ]
        }

        Alamofire.request(URL(string: "\(BASE_URL)/api/integrations\(route!)?token=\(authToken)")!, method: .post, parameters: body, encoding: JSONEncoding.default).responseString { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data)
                    let success = json["success"].boolValue
                    if (success) {
                        print(json["result"])
                        let token = json["result"]["token"].stringValue
                        try Locksmith.updateData(data: [
                            "authToken" : token,
                            ], forUserAccount: USER_AUTH)
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch let error {
                    debugPrint(error)
                }
            } else {
                completion(false)
                debugPrint(response.result.error!)
            }
        }
    }
}

