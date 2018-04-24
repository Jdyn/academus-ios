//
//  AppDelegate.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyJSON
import Locksmith

class MainNavigationController : UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var mainController = MainController()
    var isLaunch: Bool = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = mainController

        mainController.isLaunch = self.isLaunch
        
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .navigationsDarkGrey
        UINavigationBar.appearance().tintColor = .navigationsGreen
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-demibold", size: 29)!,
            NSAttributedStringKey.foregroundColor: UIColor.navigationsWhite,
        ]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "AvenirNext-demibold", size: 20)!,
            NSAttributedStringKey.foregroundColor: UIColor.navigationsWhite
        ]
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .navigationsDarkGrey
        UITabBar.appearance().tintColor = .navigationsGreen
        
        UITableView.appearance().backgroundColor = .tableViewDarkGrey
        
        UITextField.appearance().keyboardAppearance = .dark
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in }

        
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
    
        let freshchatConfig: FreshchatConfig = FreshchatConfig.init(appID: "76490582-1f11-45d5-b5b7-7ec88564c7d6", andAppKey: "5d16672f-543b-4dc9-9c21-9fd5f62a7ad3")
        freshchatConfig.themeName = "CustomFCTheme.plist"
        Freshchat.sharedInstance().initWith(freshchatConfig)
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_NOTIF)
        if dictionary?[isFirstLaunch] == nil  {
            let authDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
            
            do {
                try Locksmith.updateData(data: [
                    isAssignmentsPosted : false,
                    isCoursePosted : false,
                    isMisc : false,
                    isFirstLaunch : true
                    ], forUserAccount: USER_NOTIF)
            } catch let error {
                print(error)
            }
            
            guard
                let email = authDictionary?["email"],
                let firstName = authDictionary?["firstName"],
                let lastName = authDictionary?["lastName"],
                let isLoggedIn = authDictionary?["isLoggedIn"],
                let userID = authDictionary?["userID"]
                else {
                    return true
            }
            
            do {
                try Locksmith.updateData(data: [
                    "email" : email,
                    "firstName" : firstName,
                    "lastName" : lastName,
                    "isLoggedIn" : isLoggedIn,
                    "userID" : userID
                    ], forUserAccount: USER_INFO)
            } catch let error {
                print(error)
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        if Freshchat.sharedInstance().isFreshchatNotification(userInfo) {
            Freshchat.sharedInstance().handleRemoteNotification(userInfo, andAppstate: application.applicationState)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
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
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("TOKEN:", type(of: token))
        mainController.apnsToken = token
        mainController.notificationManager()
        Freshchat.sharedInstance().setPushRegistrationToken(deviceToken)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        var freahchatUnreadCount = Int()
        Freshchat.sharedInstance().unreadCount { (unreadCount) in
            freahchatUnreadCount = unreadCount
        }
        UIApplication.shared.applicationIconBadgeNumber = freahchatUnreadCount
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote Notifications Failure: \(error)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) { mainController.notificationManager() }
    
    func shouldDisplay(payload: JSON) -> Bool {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_NOTIF)
        let titleKey = payload["aps"]["alert"]["title-loc-key"]
        
        switch titleKey {
        case "notif_grade_posted_title", "notif_assignment_posted_title":
            return dictionary?[isAssignmentsPosted] as! Bool
        case "notif_course_grade_changed_title":
            return dictionary?[isCoursePosted] as! Bool
        default:
            return dictionary?[isMisc] as! Bool
        }
    }
}
