//
//  MainController.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class MainController: UITabBarController {
    
    var apnsToken: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        view.backgroundColor = .tableViewDarkGrey
        
        let userDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        
        if userDictionary?["isLoggedIn"] == nil {
            let welcomeController = WelcomeController()
            welcomeController.mainController = self
            let welcomeNavigationController = MainNavigationController(rootViewController: welcomeController)
            self.present(welcomeNavigationController, animated: false, completion: {
                self.setUpUI()
            })
        } else {
            self.setUpUI()
            DispatchQueue.main.async {
                let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
                print(dictionary as Any)
            }
        }
    }
    
    func setUpUI(){
        let plannerController = PlannerController()
        plannerController.tabBarItem = UITabBarItem(title: "Planner", image: #imageLiteral(resourceName: "planner"), tag: 0)
        
        let coursesController = CoursesController()
        coursesController.tabBarItem = UITabBarItem(title: "Courses", image: #imageLiteral(resourceName: "grades"), tag: 1)
        
        let settingsController = ManageController(style: .grouped)
        settingsController.tabBarItem = UITabBarItem(title: "Manage", image: #imageLiteral(resourceName: "menu"), tag: 2)
        
        let controllers = [plannerController, coursesController, settingsController]
        self.viewControllers = controllers.map { MainNavigationController(rootViewController: $0)}
        self.selectedIndex = 1
    }
    
    func notificationManager() {
        print("notification manager called")
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        let currentAppleToken = dictionary?[APPLE_TOKEN] as? String
        
        if apnsToken != currentAppleToken {
            
            let authToken = dictionary?[AUTH_TOKEN]
            
            do {
                try Locksmith.updateData(data: [
                    APPLE_TOKEN : apnsToken as Any,
                    AUTH_TOKEN : authToken as! String
                    ], forUserAccount: USER_AUTH)
                
                AuthService().registerAPNS(token: authToken as! String, appleToken: apnsToken)
                let dictionary1 = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
                print("DICTIONARY: ", dictionary1 as Any)
            } catch {
                if authToken == nil {
                    let welcomeController = WelcomeController()
                    welcomeController.mainController = self
                    let welcomeNavigationController = MainNavigationController(rootViewController: welcomeController)
                    UIApplication.shared.keyWindow?.rootViewController?.present(welcomeNavigationController, animated: false, completion: {
                        self.setUpUI()
                    })
                }
            }
        }
    }
    
}
