//
//  MainController.swift
//  Academus
//
//  Created by Jaden Smith on 4/24/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith
import LocalAuthentication


class MainController: UIViewController {
    
    var apnsToken: String?
    var appLock: Bool?
    var logo: UIImageView?
    
    var tryAgain = UIButton().setUpButton(bgColor: .tableViewMediumGrey, title: "TRY AGAIN", font: UIFont.standard!, fontColor: .navigationsGreen, state: .normal)
    var logout = UIButton().setUpButton(bgColor: .tableViewMediumGrey, title: "LOG OUT", font: UIFont.standard!, fontColor: .navigationsGreen, state: .normal)
    
    override func viewDidLoad() {
        view.backgroundColor = .tableViewMediumGrey
        
        logo = UIImageView()
        logo?.image = #imageLiteral(resourceName: "logo_colored")
        view.addSubview(logo!)
        logo?.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 128, height: 128)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)

        let settings = Locksmith.loadDataForUserAccount(userAccount: USER_SETTINGS)
        appLock = settings?[isAppLock] as? Bool

        
        if dictionary?["isLoggedIn"] == nil {
            kickUser()
        } else {
            if appLock! {
                authenticate { (success) in
                    if success {
                        self.loginUser()
                    } else {
                        self.showLockOptions()
                    }
                }
            } else {
                UIApplication.shared.shortcutItems = nil
                loginUser()
            }
        }
    }
    
    func authenticate(completion: @escaping CompletionHandler) {
        let context = LAContext()
        let reason = "Verify your identity to access Academus"
        
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            completion(false)
            switch authError! {
            default: alertMessage(title: "Try again later...", message: authError!.localizedDescription)
            }
        }
    }
    
    func showLockOptions() {
        DispatchQueue.main.async {
            self.tryAgain.isHidden = false
            self.logout.isHidden = false
            
            self.logout.addTarget(self, action: #selector(self.logoutPressed), for: .touchUpInside)
            self.tryAgain.addTarget(self, action: #selector(self.tryAgainPressed), for: .touchUpInside)
            
            UIView.transition(with: self.view, duration: 0.6, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                self.view.addSubviews(views: [self.tryAgain, self.logout])
            })
            
            self.tryAgain.anchors(top: self.logo?.bottomAnchor, topPad: 32, centerX: self.view.centerXAnchor, width: 128, height: 45 )
            self.logout.anchors(bottom: self.view.bottomAnchor, bottomPad: -32, centerX: self.view.centerXAnchor, width: 128, height: 45 )
        }
    }
    
    func loginUser() {
        DispatchQueue.main.async {
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
            let authToken = dictionary?[AUTH_TOKEN] as? String
            if authToken != nil {
                self.present(MainBarController(), animated: true, completion: {
                    let plannerIcon = UIApplicationShortcutIcon(templateImageName: "planner")
                    let coursesIcon = UIApplicationShortcutIcon(templateImageName: "grades")
                    let plannerShortcut = UIApplicationShortcutItem(type: "plannerShortcut", localizedTitle: "Planner", localizedSubtitle: nil, icon: plannerIcon)
                    let coursesShortcut = UIApplicationShortcutItem(type: "coursesShortcut", localizedTitle: "Courses", localizedSubtitle: nil, icon: coursesIcon)
                    UIApplication.shared.shortcutItems = [plannerShortcut, coursesShortcut]
                })
            } else {
                self.kickUser()
            }
        }
    }

    
    func kickUser() {
        try? Locksmith.deleteDataForUserAccount(userAccount: USER_INFO)
        
        let settings = Locksmith.loadDataForUserAccount(userAccount: USER_SETTINGS)
        var localSettings = settings
        localSettings?[isAppLock] = false
        try? Locksmith.updateData(data: localSettings!, forUserAccount: USER_SETTINGS)
        
        let welcomeController = WelcomeController()
        welcomeController.mainController = self
        let welcomeNavigationController = MainNavigationController(rootViewController: welcomeController)
        appLock = false
        
        let settings1 = Locksmith.loadDataForUserAccount(userAccount: USER_SETTINGS)
        print(settings1 as Any)
        
        tryAgain.isHidden = true
        logout.isHidden = true

        self.present(welcomeNavigationController, animated: true, completion: nil)
    }
    
    @objc func logoutPressed() {
        let alert = UIAlertController(title: "WARNING", message: "Logging out will remove the lock on your account.", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.kickUser()
        }
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alert.addAction(actionNo)
            alert.addAction(actionYes)
            self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tryAgainPressed() {
        authenticate { (success) in
            if success {
                self.loginUser()
            } else {
                return
            }
        }
    }
    
    
    func notificationTokenManager() {
        let infoDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        let apnsDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_APNS)
        
        let currentApnsToken = apnsDictionary?[APPLE_TOKEN] as? String
        let authToken = infoDictionary?[AUTH_TOKEN] as? String
        
        if (self.apnsToken != currentApnsToken) {
            if (self.apnsToken != nil) {
                if (authToken != nil) {
                    do {
                        try Locksmith.updateData(data: [APPLE_TOKEN : apnsToken!], forUserAccount: USER_APNS)
                        AuthService().registerAPNS(token: authToken!, appleToken: apnsToken!)
                        
                        return
                    } catch let error {
                        print(error)
                        return
                    }
                }
            }
        }
    }
}
