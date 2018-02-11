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
let URL_REGISTER = URL(string: "https://app.academus.io/api/register")
let URL_LOGIN = URL(string: "https://app.academus.io/api/login")


// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Headers
let HEADER =  [
    "Content-Type": "application/json; charset=utf-8"
]
