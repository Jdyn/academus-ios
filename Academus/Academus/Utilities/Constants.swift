//
//  Constants.swift
//  Academus
//
//  Created by Jaden Moore on 2/9/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation


typealias CompletetionHandler = (_ Success: Bool) -> ()


// HTTP Requesting
let BASE_URL = "https://app-test.academus.io"
let URL_REGISTER = URL(string: "\(BASE_URL)/api/register")
let URL_LOGIN = URL(string: "\(BASE_URL)/api/login")
let URL_COURSE = URL(string: "\(BASE_URL)/api/courses?token=\(AuthService.instance.authToken)")
let URL_ASSIGNMENT = URL(string: "\(BASE_URL)/api/assignments?token=\(AuthService.instance.authToken)")
let URL_GET_INTEGRATION = URL(string: "\(BASE_URL)/api/integrations/available?token=\(AuthService.instance.authToken)")
let URL_ADD_INTEGRATION = URL(string: "\(BASE_URL)/api/integrations/studentvue?token=\(AuthService.instance.authToken)")


// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Headers
let HEADER =  [
    "Content-Type": "application/json; charset=utf-8"
]
