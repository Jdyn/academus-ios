//
//  HelpController.swift
//  Academus
//
//  Created by Jaden Moore on 3/28/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageHelpController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Help"
        tableView.separatorStyle = .none
        
        tableView.backgroundView = UILabel().setUpLabel(text: "TJ GET A CHATTING SERVICE", font: UIFont.header!, fontColor: .navigationsRed)
    }
}
