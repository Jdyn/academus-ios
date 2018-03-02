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


class AuthService {
    
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
                completion(true)
                print(response)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func logInUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        let account = "userAccount"
        let body: Parameters = [
            "user":[
                "email": lowerCaseEmail,
                "password": password
            ]
        ]
        
        Alamofire.request(URL_LOGIN!, method: .post, parameters: body, encoding: JSONEncoding.default).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                let json = try! JSON(data: data)
                let success = json["success"].boolValue
                if (success) {
                    let token = json["result"]["token"].stringValue
                    let email = json["result"]["user"]["email"].stringValue
                    let isLoggedIn = true
                        do {
                            
                            try Locksmith.updateData(data: [
                                "authToken" : token,
                                "email" : email,
                                "isLoggedIn" : isLoggedIn
                                ], forUserAccount: account)
                            
                        } catch let error {
                            debugPrint(error)
                        }
                    completion(true)
                } else {
                    
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
}
