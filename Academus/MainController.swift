//
//  MainController.swift
//  Academus
//
//  Created by Jaden Smith on 4/24/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith


class MainController: UIViewController {
    
    var apnsToken: String?
    
    override func viewDidLoad() {
        view.backgroundColor = .navigationsDarkGrey
        
        let logo = UIImageView()
        logo.image = #imageLiteral(resourceName: "logo_colored")
        view.addSubview(logo)
        logo.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 128, height: 128)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let userDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        let authDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        
        if userDictionary?["isLoggedIn"] == nil {
            loginUser()
        } else {
            let authToken = authDictionary?[AUTH_TOKEN] as? String
            if authToken != nil {
                self.present(MainBarController(), animated: true, completion: nil)
            } else {
                loginUser()
            }
        }
    }
    
    func loginUser() {
        let welcomeController = WelcomeController()
        welcomeController.mainController = self
        let welcomeNavigationController = MainNavigationController(rootViewController: welcomeController)
        self.present(welcomeNavigationController, animated: true, completion: nil)
    }
    
    func notificationTokenManager() {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        let currentApnsToken = dictionary?[APPLE_TOKEN] as? String
        let authToken = dictionary?[AUTH_TOKEN] as? String
        
        if (self.apnsToken != currentApnsToken) {
            if (self.apnsToken != nil) {
                if (authToken != nil) {
                    do {
                        
                        try Locksmith.updateData(data: [
                            APPLE_TOKEN : apnsToken!,
                            AUTH_TOKEN : authToken!
                            ], forUserAccount: USER_AUTH)
                        
                        AuthService().registerAPNS(token: authToken!, appleToken: apnsToken!)
                        return
                    } catch let error {
                        print(error)
                        return
                    }
                }
            }
        }
    }
}
