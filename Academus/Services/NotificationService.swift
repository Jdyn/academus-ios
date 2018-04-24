//
//  NotificationService.swift
//  Academus
//
//  Created by Jaden Moore on 4/21/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith

class NotificationService {
    
    func patchNotificationState(didChange: Bool, completion: @escaping CompletionHandler) {
        
        if didChange {
            let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_NOTIF)
            
            let assignments = dictionary?[isAssignmentsPosted] as! Bool
            let courses = dictionary?[isCoursePosted] as! Bool
            let misc = dictionary?[isMisc] as! Bool
            
            let body: Parameters = [
                "notify_assignments": assignments,
                "notify_courses": courses,
                "notify_misc" : misc
            ]
            
            let authDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
            guard let apnsToken = authDictionary?[APPLE_TOKEN] as? String else { return }
            if apnsToken == authDictionary?[APPLE_TOKEN] as? String {
                
                let authToken = authDictionary?[AUTH_TOKEN]

                Alamofire.request(URL(string: "\(BASE_URL)/api/apns/\(apnsToken)?token=\(authToken ?? "")")!, method: .patch, parameters: body, encoding: JSONEncoding.default).responseJSON { (response) in
                    guard let data = response.data else {print("RETURNED"); return }
                    print("this was called")
                    if response.result.error == nil {
                        do {
                            let json = JSON(data)
                            let notifMisc = json["result"]["notify_misc"].boolValue
                            let notifAss = json["result"]["notify_assignments"].boolValue
                            let notifCourses = json["result"]["notify_courses"].boolValue
                            print(json)
                            try Locksmith.updateData(data: [
                                isAssignmentsPosted : notifAss,
                                isCoursePosted : notifCourses,
                                isMisc : notifMisc
                                
                                ], forUserAccount: USER_NOTIF)
                            
                            completion(true)
                        } catch let error {
                            completion(false)
                            print(error)
                        }
                        
                    } else {
                        MainController().notificationManager()
                        completion(false)
                    }
                }
            } else {
                return
            }
        }
    }
}
