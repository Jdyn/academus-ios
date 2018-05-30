//
//  statusModel.swift
//  Academus
//
//  Created by Jaden Moore on 5/3/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct ComponentModel: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let link: String?
    let status: Int?
    let order: Int?
    let groupId: Int?
    let createdAt: Date?
    let updatedAt: Date?
    let deletedAt: Date?
    let enabled: Bool?
    let statusName: String?
}
