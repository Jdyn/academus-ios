//
//  SettingsController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    var cellTypes = [CellType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellTypes = [.name, .work, .contactTypes, .message, .send]
        setupUI()
        mainTableView.reloadData()
        navigationItem.title = "Settings"
    }
}
