//
//  Integration.swift
//  Academus
//
//  Created by Jaden Moore on 2/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct Integration : Decodable {
    
    let route : String
    let name : String
    let fields : [IntegrationFields]
    let icon_url : String
}
