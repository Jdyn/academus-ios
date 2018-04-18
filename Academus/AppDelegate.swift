//
//  AppDelegate.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import Locksmith
import Crisp

class MainNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var mainController: MainController?
    var blurController: BackgroundBlurController?
    var isAuthorized: Bool?
    var apnsToken: String?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MainController()
        
        Crisp.initialize(websiteId: "0ac655eb-7e7c-4fdc-a093-5500f76e0ecd")
        
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

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        center.requestAuthorization(options: authOptions, completionHandler: { granted, error in
            guard granted else { return }
            center.getNotificationSettings { (settings) in
                print("Notification settings: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async{ application.registerForRemoteNotifications() }
            }
        })
        
        SettingsBundleHelper.setVersionAndBuildNumber()

        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        
        let data = try! JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("APNS Received Remote Message 1: \(string ?? "")")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        let data = try! JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("APNS Received Remote Message 2: \(string ?? "")")
        
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        
        let data = try! JSONSerialization.data(withJSONObject: response.notification.request.content.userInfo, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("APNS User Tapped on Notification: \(string ?? "")")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification.request.content.userInfo)
        
        let data = try! JSONSerialization.data(withJSONObject: notification.request.content.userInfo, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("APNS Received Remote Message 3: \(string ?? "")")
        
        if shouldDisplay(payload: notification.request.content.userInfo) {
            completionHandler([.alert, .sound])
        } else {
            completionHandler([])
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNS Token: \(apnsToken ?? "")")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote Notifications Failure: \(error)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        isAuthorized = false
        guard UserDefaults.standard.bool(forKey: SettingsBundleKeys.appLockPreference) == true else { return }
        guard blurController == nil else { return }
        blurController = BackgroundBlurController()
        application.keyWindow?.rootViewController?.present(blurController!, animated: true, completion: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        guard isAuthorized == true else { mainController?.localAuth(); return }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerAPNS() {
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) else { return }
        guard let token = dictionary["authToken"] as? String else { return }
        guard let appleToken = apnsToken else { return }
        
        let body: Parameters = ["apns_token": appleToken]
        Alamofire.request(URL(string: "\(BASE_URL)/api/apns?token=\(token)")!, method: .post, parameters: body, encoding: JSONEncoding.default).responseString { (response) in
            print(response)
        }
    }
    
    func shouldDisplay(payload: [AnyHashable: Any]) -> Bool {
        guard let aps = payload["aps"] as? [String: NSObject] else { return UserDefaults.standard.bool(forKey: SettingsBundleKeys.miscPreference) }
        guard let alert = aps["alert"] as? [String: NSObject] else { return UserDefaults.standard.bool(forKey: SettingsBundleKeys.miscPreference) }
        guard let titleKey = alert["title-loc-key"] as? String else { return UserDefaults.standard.bool(forKey: SettingsBundleKeys.miscPreference) }
        
        switch titleKey {
        case "notif_grade_posted_title":
            return UserDefaults.standard.bool(forKey: SettingsBundleKeys.courseGradePostedPreference)
        case "notif_course_grade_changed_title":
            return UserDefaults.standard.bool(forKey: SettingsBundleKeys.courseGradePostedPreference)
        case "notif_assignment_posted_title":
            return UserDefaults.standard.bool(forKey: SettingsBundleKeys.assignmentPostedPreference)
        default:
            return UserDefaults.standard.bool(forKey: SettingsBundleKeys.miscPreference)
        }
    }
}
