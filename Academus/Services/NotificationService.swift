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
    
    func patchNotificationState(didChange: Bool, dictionary: Dictionary<String, Any>, completion: @escaping CompletionHandler) {
        
        if didChange {
            
                let assignments = dictionary[isAssignmentsPosted] as? Bool
                let courses = dictionary[isCoursePosted] as? Bool
                let misc = dictionary[isMisc] as? Bool
            
            let body: Parameters = [
                "notify_assignments": assignments!,
                "notify_courses": courses!,
                "notify_misc" : misc!
            ]
            
            let infoDictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
            let apnsDictionray = Locksmith.loadDataForUserAccount(userAccount: USER_APNS)
            let apnsToken = apnsDictionray?[APPLE_TOKEN] as? String
            print(apnsDictionray as Any)
            
            if apnsToken != nil {
                
                let authToken = infoDictionary?[AUTH_TOKEN]

                Alamofire.request(URL(string: "\(BASE_URL)/api/apns/\(apnsToken!)?token=\(authToken ?? "")")!, method: .patch, parameters: body, encoding: JSONEncoding.default).responseJSON { (response) in
                    guard let data = response.data else {print("RETURNED"); return }
                    
                    if response.result.error == nil {
                        let json = JSON(data)
                        if json["success"].boolValue {
                            print(json)
                            
                            completion(true)
                            return
                        } else {
                            completion(false)
                        }
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
}
