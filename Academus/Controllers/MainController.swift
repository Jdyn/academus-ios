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
        
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy( LAPolicy.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "TEst", reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.setupApp()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.setupApp()
                    }
                }
            })
            
        } else {
            if let err = error {
                switch err.code{
                case LAError.Code.biometryNotEnrolled.rawValue:
                    alertMessage(title: "User is not enrolled", message: err.localizedDescription)
                case LAError.Code.passcodeNotSet.rawValue:
                    alertMessage(title: "A passcode has not been set", message: err.localizedDescription)
                case LAError.Code.biometryNotAvailable.rawValue:
                    alertMessage(title: "Biometric authentication not available", message: err.localizedDescription)
                default:
                    alertMessage(title: "Unknown error", message: err.localizedDescription)
                }
            }
        }
    }

    func setupApp() {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        if dictionary?["isLoggedIn"] == nil {
            let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
            present(welcomeNavigationController, animated: true, completion: {
                self.setUpUI()
            })
        } else {
            setUpUI()
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
        self.viewControllers = controllers.map { MainNavigationController(rootViewController: $0)}
    }
}
