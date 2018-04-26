//
//  Constants.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/21/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Locksmith

typealias CompletionHandler = (_ Success: Bool) -> ()

let BASE_URL = "https://app.academus.io"
let URL_REGISTER = URL(string: "\(BASE_URL)/api/register")
let URL_LOGIN = URL(string: "\(BASE_URL)/api/login")

let USER_AUTH = "userAuth"
let USER_APNS = "userAPNS"
let USER_INFO = "userInfo"
let USER_SETTINGS = "userNotif"


let APPLE_TOKEN = "appleToken"
let AUTH_TOKEN = "authToken"
let isAppLock = "isAppLock"
let isFirstLaunch = "isFirstLaunch1"
let isAssignmentsPosted = "isAssignmentsPosted"
let isCoursePosted = "isCoursePosted"
let isMisc = "isMisc"

let fieldHeight = CGFloat(45)

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

