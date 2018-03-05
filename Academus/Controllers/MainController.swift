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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        if dictionary?["isLoggedIn"] == nil {
            let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
            present(welcomeNavigationController, animated: false, completion: nil)
        }
    }
    
    func setUpUI(){
        let plannerController = PlannerController()
        plannerController.tabBarItem = UITabBarItem(title: "Clipboard", image: #imageLiteral(resourceName: "planner"), tag: 0)
        
        let coursesController = CoursesController()
        coursesController.tabBarItem = UITabBarItem(title: "Courses", image: #imageLiteral(resourceName: "grades"), tag: 1)
        
        let settingsController = SettingsController()
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings"), tag: 2)
        
        let controllers = [plannerController, coursesController, settingsController]
        self.viewControllers = controllers.map { MainNavigationController(rootViewController: $0)}
    }
}
