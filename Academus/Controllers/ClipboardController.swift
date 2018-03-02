//
//  clipboardController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit; import CoreData; import Locksmith

class ClipboardController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Locksmith.loadDataForUserAccount(userAccount: "userAccount") == nil {
            let welcomeNavController = MainNavigationController(rootViewController: WelcomeController())
            navigationController?.present(welcomeNavController, animated: true, completion: nil)
        }
        navigationItem.title = "Clipboard"
        setupAddButtonInNavBar(selector: #selector(handleAdd))
    }
    
    @objc func handleAdd() {
        
        if Locksmith.loadDataForUserAccount(userAccount: "userAccount") != nil {
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: "userAccount")
            } catch let error {
                debugPrint("could not delete locksmith data:", error)
            }
            let welcomeNavController = MainNavigationController(rootViewController: WelcomeController())
            navigationController?.present(welcomeNavController, animated: true, completion: {
            })
        } else {
            let welcomeNavController = MainNavigationController(rootViewController: WelcomeController())
            navigationController?.present(welcomeNavController, animated: true, completion: {
            })
        }
        
    }
}
