//
//  InvitesService.swift
//  Academus
//
//  Created by Jaden Moore on 3/25/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Locksmith
import Alamofire
import SwiftyJSON

protocol userInvitesDelegate {
    var invitesLeft: Int {get set}
    func didGetInvites(invites: [Invite])
}

class InvitesService {
    
    var delegate: userInvitesDelegate?
    
    func getInvites(completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        let authToken = dictionary?["authToken"] as! String
        Alamofire.request(URL(string: "\(BASE_URL)/api/invites?token=\(authToken)")!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    let json = try JSON(data: data)
                    let jsonResult = try json["result"].rawData()
                    let userInvites = try JSONDecoder().decode(UserInvites.self, from: jsonResult)
                    if json["success"] == true {
                        let invites = userInvites.invites_sent
                        self.delegate?.didGetInvites(invites: invites)
                        self.delegate?.invitesLeft = userInvites.invites_remaining
                        completion(true)
                    }
                } catch let error {
                    completion(false)
                    debugPrint(error)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func addInvite(completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        let authToken = dictionary?["authToken"] as! String

        Alamofire.request(URL(string: "\(BASE_URL)/api/invites/?token=\(authToken)")!, method: .post, encoding: JSONEncoding.default).responseString { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                do {
                    let json = try JSON(data: data)
                    let success = json["success"].boolValue
                    if (success) {
                        print(json["result"])
                        completion(true)
                    } else {
                        debugPrint(response.result.error)
                        print(json["result"])
                        completion(false)
                    }
                } catch let error {
                    completion(false)
                    debugPrint(error)
                }
            } else {
                completion(false)
                debugPrint(response.result.error!)
            }
        }
    }
    
}
