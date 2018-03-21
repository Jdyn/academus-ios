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
        UIDatePicker.appearance().tintColor = .navigationsWhite
        
        let plannerController = PlannerController()
        plannerController.tabBarItem = UITabBarItem(title: "Planner", image: #imageLiteral(resourceName: "planner"), tag: 0)
        
        let coursesController = CoursesController()
        coursesController.tabBarItem = UITabBarItem(title: "Courses", image: #imageLiteral(resourceName: "grades"), tag: 1)
        
        let settingsController = ManageController()
        settingsController.tabBarItem = UITabBarItem(title: "Manage", image: #imageLiteral(resourceName: "menu"), tag: 2)
        
        let controllers = [plannerController, coursesController, settingsController]
        self.viewControllers = controllers.map { MainNavigationController(rootViewController: $0)}
    }
}

class UIColoredDatePicker: UIDatePicker {
    var changed = false
    override func addSubview(_ view: UIView) {
        if !changed {
            changed = true
            self.setValue(UIColor.navigationsWhite, forKey: "textColor")
        }
        super.addSubview(view)
    }
}

