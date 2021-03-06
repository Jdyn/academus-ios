//
//  AppDelegate.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import UserNotifications
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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = mainController
        
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
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        
        UITableView.appearance().backgroundColor = .tableViewDarkGrey
        
        UITextField.appearance().keyboardAppearance = .dark
        
        let freshchatConfig: FreshchatConfig = FreshchatConfig.init(appID: "76490582-1f11-45d5-b5b7-7ec88564c7d6", andAppKey: "5d16672f-543b-4dc9-9c21-9fd5f62a7ad3")
        freshchatConfig.themeName = "CustomFCTheme.plist"
        Freshchat.sharedInstance().initWith(freshchatConfig)
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_SETTINGS)        
        if dictionary?[isFirstLaunch] == nil  {
            let authDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
            do {
                try Locksmith.updateData(data: [
                    isAppLock : false,
                    isAssignmentsPosted : true,
                    isCoursePosted : true,
                    isMisc : true,
                    isFirstLaunch : true
                    ], forUserAccount: USER_SETTINGS)
            } catch {
                return true
            }

            guard let authToken = authDictionary?[AUTH_TOKEN] else { return true }
            
            let userDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
            if var settings = userDictionary {
                do {
                    settings[AUTH_TOKEN] = authToken
                    try Locksmith.updateData(data: settings, forUserAccount: USER_INFO)
                    try Locksmith.deleteDataForUserAccount(userAccount: USER_AUTH)
                } catch {
                    return true
                }
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        if Freshchat.sharedInstance().isFreshchatNotification(userInfo) {
            Freshchat.sharedInstance().handleRemoteNotification(userInfo, andAppstate: application.applicationState)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) { completionHandler(.newData) }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APP DELEGATE TOKEN: ", token)
        mainController.apnsToken = token
        mainController.notificationTokenManager()
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
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        guard let barController = mainController.presentedViewController as? UITabBarController else {
            UserDefaults.standard.set(true, forKey: "shortcutTapped")
            
            switch shortcutItem.type {
            case "plannerShortcut": UserDefaults.standard.set(0, forKey: "preferredTab")
            case "coursesShortcut": UserDefaults.standard.set(1, forKey: "preferredTab")
            default: break
            }
            
            completionHandler(true)
            return
        }
        
        switch shortcutItem.type {
        case "plannerShortcut": barController.selectedIndex = 0
        case "coursesShortcut": barController.selectedIndex = 1
        default: break
        }
        
        completionHandler(true)
    }
}
