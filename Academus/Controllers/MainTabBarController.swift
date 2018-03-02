//
//  MainTabBarController.swift
//  SwiftData
//
//  Created by Jaden Moore on 3/1/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let clipboardController = ClipboardController()
        clipboardController.tabBarItem = UITabBarItem(title: "Clipboard", image: #imageLiteral(resourceName: "planner"), tag: 0)
        
        let coursesController = CoursesController()
        coursesController.tabBarItem = UITabBarItem(title: "Courses", image: #imageLiteral(resourceName: "grades"), tag: 1)
        
        let settingsController = SettingsController()
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings"), tag: 2)
        
        let controllers = [clipboardController, coursesController, settingsController]
        
        self.viewControllers = controllers.map { MainNavigationController(rootViewController: $0)}
    }
}
