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

let dictionary = Locksmith.loadDataForUserAccount(userAccount: "userAccount")


let token = dictionary?["authToken"]
let BASE_URL = "https://app-test.academus.io"
let URL_REGISTER = URL(string: "\(BASE_URL)/api/register")
let URL_LOGIN = URL(string: "\(BASE_URL)/api/login")

let URL_COURSE = URL(string: "\(BASE_URL)/api/courses?token=\(token!)")
let URL_ASSIGNMENT = URL(string: "\(BASE_URL)/api/assignments?token=\(token!)&no_grouping=true")

let URL_GET_INTEGRATION = URL(string: "\(BASE_URL)/api/integrations/available?token=bd42f7289d60f464c731af50101167164a3b7c053675333bb93875fc94664d1b1127fcc114d30bcc3d074a18ebdee1a7e348edc712b7976d0a6627092017d865")

let USER_ACCOUNT = "userAccount"

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
