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
import Locksmith

protocol logInErrorDelegate {
    var logInError: String {get set}
}

class AuthService {
    
    var logInErrorDelegate: logInErrorDelegate?
    
    func registerUser(betaCode: String, firstName: String, lastName: String, email:String, password: String, appleToken: String?, completion: @escaping CompletionHandler) {
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
                
                let json = JSON(data)
                let success = json["success"].boolValue
                
                if (success) {
                    
                    let token = json["result"]["token"].stringValue
                    let email = json["result"]["user"]["email"].stringValue
                    let firstName = json["result"]["user"]["first_name"].stringValue
                    let lastName = json["result"]["user"]["last_name"].stringValue
                    let userID = json["result"]["user"]["id"].stringValue
                    let isLoggedIn = true
                    
                    Freshchat.sharedInstance().identifyUser(withExternalID: userID, restoreID: nil)
                    let user = FreshchatUser.sharedInstance()
                    
                    user?.firstName = firstName
                    user?.lastName = lastName
                    user?.email = email
                    
                    Freshchat.sharedInstance().setUser(user)
                    
                    do {
                        
                        try Locksmith.updateData(data: [
                            "email" : email,
                            "firstName" : firstName,
                            "lastName" : lastName,
                            "isLoggedIn" : isLoggedIn,
                            "userID" : userID
                            ], forUserAccount: USER_INFO)
                        
                        try Locksmith.updateData(data: [
                            APPLE_TOKEN : appleToken ?? "nil",
                            AUTH_TOKEN : token
                            ], forUserAccount: USER_AUTH)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.registerAPNS(token: token, appleToken: appleToken ?? "")
                        })
                        
                        completion(true)
                    } catch let error {
                        completion(false)
                        debugPrint(error)
                    }
                    
                } else {
                    completion(false)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error!)
            }
        }
    }
    
    func logInUser(email: String, password: String, appleToken: String?, completion: @escaping CompletionHandler) {
        
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
                
                let json = JSON(data)
                let success = json["success"].boolValue
                if (success) {
                    let token = json["result"]["token"].stringValue
                    let email = json["result"]["user"]["email"].stringValue
                    let firstName = json["result"]["user"]["first_name"].stringValue
                    let lastName = json["result"]["user"]["last_name"].stringValue
                    let userID = json["result"]["user"]["id"].stringValue
                    let isLoggedIn = true
                    
                    Freshchat.sharedInstance().identifyUser(withExternalID: userID, restoreID: nil)
                    
                    let user = FreshchatUser.sharedInstance()
                    
                    user?.firstName = firstName
                    user?.lastName = lastName
                    user?.email = email
                    
                    Freshchat.sharedInstance().setUser(user)
                    do {

                        try Locksmith.updateData(data: [
                            "email" : email,
                            "firstName" : firstName,
                            "lastName" : lastName,
                            "isLoggedIn" : isLoggedIn,
                            "userID" : userID
                            ], forUserAccount: USER_INFO)
                        
                        try Locksmith.updateData(data: [
                            APPLE_TOKEN : appleToken ?? "nil",
                            AUTH_TOKEN : token
                            ], forUserAccount: USER_AUTH)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.registerAPNS(token: token, appleToken: appleToken)
                        })
                            
                        completion(true)
                    } catch let error {
                        debugPrint("LOG IN CATCH ERROR: ", error)
                    }
                } else {
                    self.logInErrorDelegate?.logInError = json["error"].stringValue
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func registerAPNS(token: String, appleToken: String?) {

        if appleToken == "nil" {
            
            let body: Parameters = ["apns_token": appleToken ?? "nil"]
            
            Alamofire.request(URL(string: "\(BASE_URL)/api/apns?token=\(token)")!, method: .post, parameters: body, encoding: JSONEncoding.default).responseString { (response) in
                print(response)
                print(appleToken as Any)
            }
        } else {
            print("APNS TOKEN IS EMPTY")
        }
    }
}
