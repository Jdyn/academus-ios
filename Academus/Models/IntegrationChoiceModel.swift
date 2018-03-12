//
//  GetIntegrationModel.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct IntegrationChoice: Decodable {
    
    let route: String?
    let name: String?
    let icon_url: String?
    let fields: [fields]
    struct fields: Decodable {
        let id: String?
        let label: String?
    }
}
