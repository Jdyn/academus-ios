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
    
    var mainBarController = MainBarController()
    var apnsToken: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let userDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        
        if userDictionary?["isLoggedIn"] == nil {
            let welcomeController = WelcomeController()
            let welcomeNavigationController = MainNavigationController(rootViewController: welcomeController)
            self.present(welcomeController, animated: false, completion: {
                
            })
        } else {
            self.present(mainBarController, animated: false, completion: nil)

        }
    }

        func notificationManager() {
        print("NOTIFICATION MANAGER CALLED")
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        
        let currentAppleToken = dictionary?[APPLE_TOKEN] as? String
        let authToken = dictionary?[AUTH_TOKEN] as? String
        
        if (authToken != nil) {
            if apnsToken != currentAppleToken {
                if (apnsToken != nil) {
                    do {
                        try Locksmith.updateData(data: [
                            APPLE_TOKEN : apnsToken!,
                            AUTH_TOKEN : authToken!
                            ], forUserAccount: USER_AUTH)
                        
                        AuthService().registerAPNS(token: authToken!, appleToken: apnsToken)
                    } catch {
//                        if authToken == nil {
//                            let welcomeController = WelcomeController()
//                            welcomeController.mainController = self
//                            let welcomeNavigationController = MainNavigationController(rootViewController: welcomeController)
//                            UIApplication.shared.keyWindow?.rootViewController?.present(welcomeNavigationController, animated: false, completion: {
//                                self.setUpUI()
//                            })
//                        }
                    }
                } else {
                    return
                }
            }
        } else {
            return
        }
    }
}
