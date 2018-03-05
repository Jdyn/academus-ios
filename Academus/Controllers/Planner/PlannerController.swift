//
//  PlannerController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class PlannerController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Clipboard"
        setupAddButtonInNavBar(selector: #selector(handleAdd))
    }
    
    @objc func handleAdd() {
        
        if Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) != nil {
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: USER_AUTH)
            } catch let error {
                debugPrint("could not delete locksmith data:", error)
                return
            }
            let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
            present(welcomeNavigationController, animated: true, completion: nil)
        } else {
            let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
            present(welcomeNavigationController, animated: true, completion: nil)
        }
        
    }
}
