//
//  AuthService.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreData
import Locksmith

protocol logInErrorDelegate {
    var logInError: String {get set}
}

class AuthService {
    
    var logInErrorDelegate: logInErrorDelegate?
    
    func registerUser(betaCode: String, firstName: String, lastName: String, email:String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
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
                        
                        let token = json["result"]["token"].stringValue

                        try Locksmith.updateData(data: [
                            "authToken" : token,
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
    
    func logInUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: Parameters = [
            "user":[
                "email": lowerCaseEmail,
                "password": password
            ]
        ]
        
        Alamofire.request(URL_LOGIN!, method: .post, parameters: body, encoding: JSONEncoding.default).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                    do {
                        
                        let json = try JSON(data: data)
                        let success = json["success"].boolValue
                        if (success) {
                            
                            let token = json["result"]["token"].stringValue
                            let email = json["result"]["user"]["email"].stringValue
                            let firstName = json["result"]["user"]["first_name"].stringValue
                            let lastName = json["result"]["user"]["last_name"].stringValue
                            let isLoggedIn = true
                            
                            try Locksmith.updateData(data: [
                                "authToken" : token,
                                "email" : email,
                                "firstName" : firstName,
                                "lastName" : lastName,
                                "isLoggedIn" : isLoggedIn
                                ], forUserAccount: USER_AUTH)
                            
                            completion(true)
                        } else {
                            self.logInErrorDelegate?.logInError = json["error"].stringValue
                            completion(false)
                        }
                    } catch let error {
                        debugPrint(error)
                    }
                
            } else {
                completion(false)
            }
        }
    }
}
