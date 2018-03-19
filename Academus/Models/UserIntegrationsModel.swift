//
//  UserIntegrationsModel.swift
//  Academus
//
//  Created by Jaden Moore on 3/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct UserIntegrations: Decodable {
    let id: Int?
    let type: String?
    let name: String?
    let categories: [String]?
    let last_synced: Date?
    let last_sync_did_error: Bool?
    let sync_error_reason: String?
    let syncing: Bool?
    let icon_url: String?
    let created_at: Date?
}
