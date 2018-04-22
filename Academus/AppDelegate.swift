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
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        
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
//        print("THIS WAS CALLED")
//        let data = JSON(userInfo).rawString()
//        print("APNS Received Remote Message 1: \(data ?? "Error")")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("DID RECEIVE REMOTE NOTIF", userInfo)
//
//        let data = JSON(userInfo)
//        if shouldDisplay(payload: data) {
//            completionHandler(.newData)
//        } else {
//            return
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("WILL PRESENT IS CALLED", notification.request.content.userInfo)
//
//        let data = JSON(notification.request.content.userInfo)
//        if shouldDisplay(payload: data) {
//            completionHandler([.alert, .sound])
//        } else {
//            completionHandler([])
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) { completionHandler() }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        mainController.apnsToken = token
        mainController.notificationManager()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote Notifications Failure: \(error)")
    }
    
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
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        mainController.notificationManager()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        var freahchatUnreadCount = Int()
        Freshchat.sharedInstance().unreadCount { (unreadCount) in
            freahchatUnreadCount = unreadCount
        }
        UIApplication.shared.applicationIconBadgeNumber = freahchatUnreadCount
    }

    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }



    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
