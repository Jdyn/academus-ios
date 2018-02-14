//
//  Assignment.swift
//  Academus
//
//  Created by Jaden Moore on 2/12/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

struct Assignment : Decodable {
    
    let upcoming : [AssignmentEntry]!
    let others : [AssignmentEntry]
}
