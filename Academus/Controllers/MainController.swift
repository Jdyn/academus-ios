//
//  MainController.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith
import LocalAuthentication

class MainController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        view.backgroundColor = .tableViewDarkGrey
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        if dictionary?["isLoggedIn"] == nil {
            let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
            present(welcomeNavigationController, animated: true, completion: { self.setUpUI() })
        } else {
            let context = LAContext()
            
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock", reply: { (success, error) in
                    guard error == nil else {
                        print(error as Any)
                        self.alertMessage(title: "Authentication Failed", message: "Please login again to confirm your identity.")
                        self.kickUser()
                        return
                    }
                    
                    DispatchQueue.main.async { self.setUpUI() }
                })
            } else {
                DispatchQueue.main.async { self.setUpUI() }
            }
        }
    }
    
    func setUpUI(){
        let plannerController = PlannerController()
        plannerController.tabBarItem = UITabBarItem(title: "Planner", image: #imageLiteral(resourceName: "planner"), tag: 0)
        
        let coursesController = CoursesController()
        coursesController.tabBarItem = UITabBarItem(title: "Courses", image: #imageLiteral(resourceName: "grades"), tag: 1)
        
        let settingsController = ManageController()
        settingsController.tabBarItem = UITabBarItem(title: "Manage", image: #imageLiteral(resourceName: "menu"), tag: 2)
        
        let controllers = [plannerController, coursesController, settingsController]
        self.viewControllers = controllers.map { MainNavigationController(rootViewController: $0) }
    }
    
    func kickUser() {
        do { try Locksmith.deleteDataForUserAccount(userAccount: USER_AUTH) } catch {}
        
        let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
        self.present(welcomeNavigationController, animated: true, completion: { self.setUpUI() })
    }
}
