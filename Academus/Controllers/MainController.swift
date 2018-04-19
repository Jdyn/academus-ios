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
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)

        if dictionary?["isLoggedIn"] == nil {
            let welcomeController = WelcomeController()
            welcomeController.mainController = self
            let welcomeNavigationController = MainNavigationController(rootViewController: welcomeController)
            present(welcomeNavigationController, animated: false, completion: {
                self.setUpUI()
            })
        } else {
            setUpUI()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                let dictionary1 = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
                print(dictionary1)
            })
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
}
