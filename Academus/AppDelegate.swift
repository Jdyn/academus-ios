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
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import Locksmith
import Crisp

class MainNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var mainController: MainController?
    var blurController: BackgroundBlurController?
    var isAuthorized: Bool?
    var apnsToken: String?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = MainController() //MainNavigationController(rootViewController: IntegrationSelectController())
        
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
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if let token = InstanceID.instanceID().token() {
            print("InstanceID: \(token)")
        }
        
        application.applicationIconBadgeNumber = 0

        return true
    }
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        let data = try! JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("FCM Received Remote Message: \(string ?? "")")
        
        parse(payload: remoteMessage.appData)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let data = try! JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
        let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("APNS Received Remote Message: \(string ?? "")")
        
        parse(payload: userInfo)
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
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
    
    func parse(payload: [AnyHashable: Any]) {
        let content = UNMutableNotificationContent()
        
        guard let message = payload as? [String : NSObject] else { return }
        guard let type = message["type"] as? String else { return }
        switch type {
        case "grade_posted":
            guard let courseName = message["course_name"] as? String else { return }
            guard let assignmentName = message["assignment_name"] as? String else { return }
            content.title = "New grade posted"
            content.body = "A new grade for \(assignmentName) in \(courseName) has been posted."
        case "course_grade_changed":
            guard let courseName = message["course_name"] as? String else { return }
            guard let newGrade = message["new_grade"] as? String else { return }
            content.title = "Course grade updated"
            content.body = "Your grade in \(courseName) is now \(newGrade)."
        case "assignment_posted":
            guard let courseName = message["course_name"] as? String else { return }
            guard let assignmentName = message["assignment_name"] as? String else { return }
            content.title = "New assignment posted"
            content.body = "A new assignment has been posted in \(courseName): \(assignmentName)."
        default:
            return
        }
        
        content.sound = UNNotificationSound.default()
        let identifier = "LocalNotification"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async{
                    if UIApplication.shared.applicationState == .background {
                        UIApplication.shared.applicationIconBadgeNumber += 1
                    }
                }
            }
        })
    }
}
