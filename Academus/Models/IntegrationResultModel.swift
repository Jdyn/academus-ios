//
//  IntegrationResult.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 5/11/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct IntegrationResult: Decodable {
    let id: String?
    let name: String?
    let address: String?
    let api_base: URL?
}
