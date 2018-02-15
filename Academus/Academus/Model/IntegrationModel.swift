//
//  IntegrationModel.swift
//  Academus
//
//  Created by Jaden Moore on 2/14/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct IntegrationModel : Decodable {
    let success : Bool!
    let result : [IntegrationResult]
}

struct IntegrationResult : Decodable {
    let route : String!
    let name : String!
    let fields : [IntegrationField]
    let icon_url : String!
}

struct IntegrationField : Decodable {
    let id : String! // username
    let label : String! // password
}

struct Integration {
    let integrationRoute : String!
    let integrationName : String!
    let integrationIcon : String!
}

