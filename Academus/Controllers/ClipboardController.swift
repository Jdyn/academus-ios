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
        navigationItem.title = "Clipboard"
        setupAddButtonInNavBar(selector: #selector(handleAdd))
    }
    
    @objc func handleAdd() {
        
        if Locksmith.loadDataForUserAccount(userAccount: USER_ACCOUNT) != nil {
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: USER_ACCOUNT)
            } catch let error {
                debugPrint("could not delete locksmith data:", error)
                return
            }
            let welcomeController = WelcomeController()
            let welcomeNavigationController = MainNavigationController(rootViewController: welcomeController)
            
            navigationController?.present(welcomeNavigationController, animated: true, completion: nil)
//            present(welcomeNavigationController, animated: true, completion: nil)
        } else {
            print("hello")
        }
        
    }
}
