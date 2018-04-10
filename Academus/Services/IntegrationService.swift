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

protocol IntegrationChoiceDelegate {
    func didGetIntegration(integrations: [IntegrationChoice])
}

protocol UserIntegrationsDelegate {
    func didGetUserIntegrations(integrations: [UserIntegrations])
}

class IntegrationService {

    var integrationChoiceDelegate : IntegrationChoiceDelegate?
    var userIntegrationsDelegate : UserIntegrationsDelegate?
    
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
                        print(integrations)
                        self.integrationChoiceDelegate?.didGetIntegration(integrations: integrations)
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
        guard let route = integration?.route else {return}
        
        var fieldsID = [String]()
        var textFields = [String]()
    
        for i in 0...fields.count - 1 {
            fieldsID.append((integration?.fields[i].id)!)
            textFields.append(fields[i].text!)
        }
        
        let body = Dictionary(uniqueKeysWithValues: zip(fieldsID, textFields))

        Alamofire.request(URL(string: "\(BASE_URL)/api/integrations/\(route)?token=\(authToken)")!, method: .post, parameters: body, encoding: JSONEncoding.default).responseString { (response) in
        
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data)
                    let success = json["success"].boolValue
                    if (success) {
                        let isLoggedIn = true
                        
                        try Locksmith.updateData(data: [
                            "isLoggedIn" : isLoggedIn
                            ], forUserAccount: USER_AUTH)
                        completion(true)
                    } else {
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
    
    func userIntegrations(completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        let authToken = dictionary?["authToken"] as! String
        
        Alamofire.request(URL(string: "\(BASE_URL)/api/integrations?token=\(authToken)")!, method: .get, encoding: JSONEncoding.default).responseString { (response) in
            
        if response.result.error == nil {
                
            guard let data = response.data else {return}
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let json = try JSON(data: data)
                let jsonResult = try json["result"].rawData()
                let integrations = try decoder.decode([UserIntegrations].self, from: jsonResult)
                if json["success"] == true {
                    self.userIntegrationsDelegate?.didGetUserIntegrations(integrations: integrations)
                    completion(true)
                } else {
                    print("failed to get users integrations")
                    completion(false)
                }
            } catch let error {
                completion(false)
                debugPrint(error)
            }
            }
        }
    }
    
    func syncIntegration(id: Int, completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        let authToken = dictionary?["authToken"] as! String
        
        Alamofire.request(URL(string: "\(BASE_URL)/api/integrations/\(id)/sync?token=\(authToken)")!, method: .post, encoding: JSONEncoding.default).responseString { (response) in
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data)
                    let success = json["success"].boolValue
                    
                    if (success) {
                        
                        completion(true)
                    } else {
                        print("failed to sync integrations")
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

