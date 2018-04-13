//
//  PlannerCreateController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import CoreData

class PlannerCreateCardController: UITableViewController {
    
    var cellTypes = [CardFormManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create a Card"
        setupCancelButtonInNavBar()
    }
}
