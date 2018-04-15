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
        
        (UIApplication.shared.delegate as! AppDelegate).mainController = self
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        if dictionary?["isLoggedIn"] == nil {
            let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
            present(welcomeNavigationController, animated: true, completion: { self.setUpUI() })
        } else {
            let context = LAContext()
            
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Unlock", reply: { (success, error) in
                    guard error == nil else {
                        if let err = error as NSError? {
                            if err.code == LAError.Code.userFallback.rawValue { return }
                        }
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
    
    func setUpUI() {
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
        let alert = UIAlertController(title: "Authentication Failed", message: "Please login again to confirm your identity.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            do { try Locksmith.deleteDataForUserAccount(userAccount: USER_AUTH) } catch {}
            
            let welcomeNav = WelcomeController()
            let mainNav = MainNavigationController(rootViewController: welcomeNav)
            UIApplication.shared.keyWindow?.rootViewController?.present(mainNav, animated: true, completion: nil)
        })
        alert.addAction(action)
        
        DispatchQueue.main.async { self.present(alert, animated: true, completion: nil) }
    }
}
