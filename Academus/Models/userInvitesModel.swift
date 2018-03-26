//
//  userInvitesModel.swift
//  Academus
//
//  Created by Jaden Moore on 3/25/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct UserInvites: Decodable {
    let invites_remaining: Int
    let invites_sent: [Invite]
}
struct Invite: Decodable {
    let id: Int
    let redeemed: Bool
    let redeemer_name: String?
    let code: String?
}
