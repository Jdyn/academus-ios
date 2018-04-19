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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = mainController //MainNavigationController(rootViewController: IntegrationSelectController())
        
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
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
        }
        
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
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        
        guard let userID = dictionary?["userID"] else { return true }
        guard let firstName = dictionary?["firstName"] else { return true }
        guard let lastName = dictionary?["lastName"] else { return true }
        guard let email = dictionary?["email"] else { return true }

        Freshchat.sharedInstance().identifyUser(withExternalID: userID as! String, restoreID: nil)
        
        let user = FreshchatUser.sharedInstance()
        
        user?.firstName = firstName as! String
        user?.lastName = lastName as! String
        user?.email = email as! String
        
        Freshchat.sharedInstance().setUser(user)
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        let data = JSON(userInfo).rawString()
        print("APNS Received Remote Message 1: \(data ?? "Error")")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let data = JSON(userInfo).rawString()
        print("APNS Received Remote Message 2: \(data ?? "")")
        
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        
        let data = JSON(response.notification.request.content.userInfo).rawString()
        print("APNS User Tapped on Notification: \(data ?? "Tapped Error")")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.userInfo)
        
        let data = JSON(notification.request.content.userInfo).rawString()
        print("APNS Received Remote Message 3: \(data ?? "")")

        completionHandler([.alert, .sound])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        mainController.apnsToken = token
        print("APP DELEGATE: ", mainController.apnsToken!)
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        guard let currentAppleToken = dictionary?[APPLE_TOKEN] else { print("RETURNEED"); return }
        
        if token != currentAppleToken as! String {
            
            print("APP DELEGATE TOKEN: ", token)
            print("MY TOKEN: ", currentAppleToken)
            
            let authToken = dictionary![AUTH_TOKEN] as! String
            AuthService().registerAPNS(token: authToken, appleToken: token)
            do {
                try Locksmith.updateData(data: [
                    APPLE_TOKEN : token,
                    AUTH_TOKEN : authToken
                    ], forUserAccount: USER_AUTH)
            } catch {
                if authToken.isEmpty {
                    let welcomeController = WelcomeController()
                    welcomeController.mainController = mainController
                    let welcomeNavigationController = MainNavigationController(rootViewController: welcomeController)
                    UIApplication.shared.keyWindow?.rootViewController?.present(welcomeNavigationController, animated: false, completion: {
                        self.mainController.setUpUI()
                    })
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote Notifications Failure: \(error)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        var freahchatUnreadCount = Int()
        Freshchat.sharedInstance().unreadCount { (unreadCount) in
            freahchatUnreadCount = unreadCount
        }
        UIApplication.shared.applicationIconBadgeNumber = freahchatUnreadCount

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
