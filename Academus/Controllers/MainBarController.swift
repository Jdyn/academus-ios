//
//  MainController.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith
import UserNotifications

class MainBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tableViewDarkGrey
        setUpUI()
        setUpShortcuts()
        notificationPresent()
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        if dictionary?["isLoggedIn"] != nil {
            self.becomeFirstResponder()
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            Freshchat.sharedInstance().showConversations(self)
        }
    }
    
    func setUpUI() {
        let plannerController = PlannerController()
        plannerController.tabBarItem = UITabBarItem(title: "Planner", image: #imageLiteral(resourceName: "planner"), tag: 0)
        
        let coursesController = CoursesController()
        coursesController.tabBarItem = UITabBarItem(title: "Courses", image: #imageLiteral(resourceName: "grades"), tag: 1)
        
        let settingsController = ManageController(style: .grouped)
        settingsController.tabBarItem = UITabBarItem(title: "Manage", image: #imageLiteral(resourceName: "menu"), tag: 2)
        
        let controllers = [plannerController, coursesController, settingsController]
        self.viewControllers = controllers.map { MainNavigationController(rootViewController: $0)}
    }
    
    func setUpShortcuts() {
        let plannerIcon = UIApplicationShortcutIcon(templateImageName: "planner")
        let coursesIcon = UIApplicationShortcutIcon(templateImageName: "grades")
        let plannerShortcut = UIApplicationShortcutItem(type: "plannerShortcut", localizedTitle: "Planner", localizedSubtitle: nil, icon: plannerIcon)
        let coursesShortcut = UIApplicationShortcutItem(type: "coursesShortcut", localizedTitle: "Courses", localizedSubtitle: nil, icon: coursesIcon)
        UIApplication.shared.shortcutItems = [plannerShortcut, coursesShortcut]
    }
}

extension MainBarController: UNUserNotificationCenterDelegate {
    
    func notificationPresent() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let NotificationAuthOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: NotificationAuthOptions) { (success, error) in
            if success {
                center.getNotificationSettings(completionHandler: { (settings) in
                    if settings.authorizationStatus != .authorized {
                        return
                    } else {
                        DispatchQueue.main.async(execute: { UIApplication.shared.registerForRemoteNotifications() })
                    }
                })
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if Freshchat.sharedInstance().isFreshchatNotification(response.notification.request.content.userInfo) {
            Freshchat.sharedInstance().handleRemoteNotification(response.notification.request.content.userInfo, andAppstate: UIApplication.shared.applicationState)
        } else {
            completionHandler()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if Freshchat.sharedInstance().isFreshchatNotification(notification.request.content.userInfo) {
            Freshchat.sharedInstance().handleRemoteNotification(notification.request.content.userInfo, andAppstate: UIApplication.shared.applicationState)  //Handled for freshchat notifications
        }
        completionHandler([.alert, .sound, .badge])
    }
}
