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
    var freshLaunch = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        view.backgroundColor = .tableViewDarkGrey
        
        (UIApplication.shared.delegate as! AppDelegate).mainController = self
        
        if freshLaunch == true {
            freshLaunch = false
            DispatchQueue.main.async { self.setUpUI() }
            self.selectedIndex = 1
        }
        
        guard (UIApplication.shared.delegate as! AppDelegate).isAuthorized == true else {
            localAuth()
            return
        }
    }
    
    @objc func localAuth() {
        guard UserDefaults.standard.bool(forKey: SettingsBundleKeys.appLockPreference) == true else {
            clearBlur()
            return
        }
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        if dictionary?["isLoggedIn"] == nil {
            let welcomeNav = WelcomeController()
            let mainNav = MainNavigationController(rootViewController: welcomeNav)
            UIApplication.shared.keyWindow?.rootViewController?.present(mainNav, animated: true, completion: { self.clearBlur() })
        } else {
            let context = LAContext()

            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate to continue.", reply: { (success, error) in
                    guard error == nil else {
                        if let err = error as NSError? {
                            if err.code == LAError.Code.userFallback.rawValue { return }
                        }
                        
                        DispatchQueue.main.async {
                            if let blurController = (UIApplication.shared.delegate as! AppDelegate).blurController { blurController.lockApp() }
                        }
                        
                        return
                    }

                    DispatchQueue.main.async { self.clearBlur() }
                })
            } else {
                DispatchQueue.main.async { self.clearBlur() }
            }
        }
        
        (UIApplication.shared.delegate as! AppDelegate).isAuthorized = true
    }
    
    func clearBlur() {
        setUpUI()
        if let blurController = (UIApplication.shared.delegate as! AppDelegate).blurController {
            blurController.dismiss(animated: true, completion: {
                (UIApplication.shared.delegate as! AppDelegate).blurController = nil
            })
        }
    }
    
    func setUpUI() {
        let plannerController = PlannerController()
        plannerController.tabBarItem = UITabBarItem(title: "Planner", image: #imageLiteral(resourceName: "planner"), tag: 0)
        
        let coursesController = CoursesController()
        setUp(coursesController: coursesController)
        coursesController.tabBarItem = UITabBarItem(title: "Courses", image: #imageLiteral(resourceName: "grades"), tag: 1)
        
        let settingsController = ManageController(style: .grouped)
        settingsController.tabBarItem = UITabBarItem(title: "Manage", image: #imageLiteral(resourceName: "menu"), tag: 2)
        
        let controllers = [plannerController, coursesController, settingsController]
        self.viewControllers = controllers.map { MainNavigationController(rootViewController: $0) }
    }
    
    func setUp(coursesController: CoursesController) {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) else {return}
        coursesController.authToken = (dictionary["authToken"] as? String ?? "")
        
        coursesController.courseService.delegate = coursesController
        let localToken = (dictionary["authToken"] as? String ?? "")
        if localToken != coursesController.authToken {
            print("Fetching courses because the token has changed...")
            coursesController.fetchCourses(token: localToken, completion: { (success) in
                if success {
                    UIView.transition(with: coursesController.tableView, duration: 0.2, options: .transitionCrossDissolve, animations: { coursesController.tableView.reloadData() })
                    coursesController.errorLabel(show: false)
                } else {
                    coursesController.errorLabel(show: true)
                }
            })
            return
        }
        
        if coursesController.tableView.visibleCells.isEmpty {
            print("Fetching courses because the table reloaded...")
            freshLaunch = false
            coursesController.fetchCourses(token: localToken, completion: { (success) in
                if success {
                    UIView.transition(with: coursesController.tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        coursesController.tableView.reloadData()
                    })
                    coursesController.errorLabel(show: false)
                } else {
                    coursesController.errorLabel(show: true)
                }
            })
            return
        }
    }
}
