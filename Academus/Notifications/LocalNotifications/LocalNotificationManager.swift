//
//  NotificationManager.swift
//  Academus
//
//  Created by Jaden Moore on 3/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    
    func setUpNotifications(title: String, body: String, sound: UNNotificationSound, timeInterval: Double, repeats: Bool, indentifier: String) {
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = sound
        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: <#T##DateComponents#>, repeats: repeats)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error as Any)
            print("Notification created")
        }
    }
}
