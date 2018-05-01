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

protocol accountCreateErrorDelegate {
    var accountCreateError: String {get set}
}

class AuthService {
    
    var logInErrorDelegate: logInErrorDelegate?
    var accountCreateDelegate: accountCreateErrorDelegate?
    
    func registerUser(firstName: String, lastName: String, email:String, password: String, appleToken: String?, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let body: Parameters = [
            "beta_code": "SMHS",
            "user": [
                "first_name": firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                "last_name": lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                "email": lowerCaseEmail.trimmingCharacters(in: .whitespacesAndNewlines),
                "password": password
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
                            "userID" : userID,
                            AUTH_TOKEN : token
                            ], forUserAccount: USER_INFO)
                        
                        try Locksmith.updateData(data: [ APPLE_TOKEN : appleToken as Any ], forUserAccount: USER_APNS)
                        
                        let infoDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
                        let apnsDictionray = Locksmith.loadDataForUserAccount(userAccount: USER_APNS)
                        print("INFO: ", infoDictionary as Any)
                        print("APNS: ", apnsDictionray as Any)
                        
                        completion(true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.registerAPNS(token: token, appleToken: appleToken ?? "")
                        })
                        
                    } catch let error {
                        completion(false)
                        debugPrint(error)
                    }
                    
                } else {
                    self.accountCreateDelegate?.accountCreateError = json["error"].stringValue
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
                            "userID" : userID,
                            AUTH_TOKEN : token
                            ], forUserAccount: USER_INFO)
                        
                        try Locksmith.updateData(data: [ APPLE_TOKEN : appleToken as Any ], forUserAccount: USER_APNS)
                        
                        let infoDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
                        let apnsDictionray = Locksmith.loadDataForUserAccount(userAccount: USER_APNS)
                        print("INFO: ", infoDictionary as Any)
                        print("APNS: ", apnsDictionray as Any)
                        
                        completion(true)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.registerAPNS(token: token, appleToken: appleToken)
                        })
                        
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

        guard appleToken != nil else {print("REGISTER APNS RETURNED"); return }
        let body: Parameters = ["apns_token": appleToken!]
            
        Alamofire.request(URL(string: "\(BASE_URL)/api/apns?token=\(token)")!, method: .post, parameters: body, encoding: JSONEncoding.default).responseString { (response) in
            print(response)
        }
        print("APNS TOKEN DID CHANGE")
    }
}
