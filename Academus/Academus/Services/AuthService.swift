//
//  AuthService.swift
//  Academus
//
//  Created by Jaden Moore on 2/9/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let instance = AuthService()
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        } set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as! String
        } set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        } set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    func registerUser(betaCode: String, firstName: String, lastName: String, email:String, password: String,
                    completion: @escaping CompletetionHandler) {
        
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
        
        Alamofire.request(URL_REGISTER!, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
        
            if response.result.error == nil {
                completion(true)
                print(response)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func logInUser(email: String, password: String, completion: @escaping CompletetionHandler) {
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
                let json = try! JSON(data: data)
                let success = json["success"].boolValue
                if (success) {
                    self.userEmail = json["result"]["user"].stringValue
                    self.authToken = json["result"]["token"].stringValue
                    self.isLoggedIn = true
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
 }
