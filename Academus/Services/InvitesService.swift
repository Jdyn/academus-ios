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
    func didGetInvites(invites: [Invite], invitesLeft: Int)
}

protocol userAddInviteDelegate {
    func didAddInvite(invite: Invite)
}

class InvitesService {
    
    var inviteDelegate: userInvitesDelegate?
    var addInviteDelegate: userAddInviteDelegate?
    
    func getInvites(completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        let authToken = dictionary?["authToken"] as! String
        Alamofire.request(URL(string: "\(BASE_URL)/api/invites?token=\(authToken)")!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    let json = JSON(data)
                    let jsonResult = try json["result"].rawData()
                    let userInvites = try JSONDecoder().decode(UserInvites.self, from: jsonResult)
                    if json["success"] == true {
                        let invites = userInvites.invites_sent
                        let invitesLeft = userInvites.invites_remaining
                        self.inviteDelegate?.didGetInvites(invites: invites, invitesLeft: invitesLeft)
                        completion(true)
                    }
                } catch let error {
                    completion(false)
                    debugPrint("Invite service error: ", error)
                }
            } else {
                completion(false)
            }
        }
    }
    
    func addInvite(completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        let authToken = dictionary?["authToken"] as! String

        Alamofire.request(URL(string: "\(BASE_URL)/api/invites/?token=\(authToken)")!, method: .post, encoding: JSONEncoding.default).responseString { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else {return}
                do {
                    let json = JSON(data)
                    let jsonResult = try json["result"].rawData()
                    let addInvite = try JSONDecoder().decode(Invite.self, from: jsonResult)
                    let success = json["success"].boolValue
                    if (success) {
                        self.addInviteDelegate?.didAddInvite(invite: addInvite)
                        completion(true)
                    } else {
                        print(json["result"])
                        completion(false)
                    }
                } catch let error {
                    completion(false)
                    debugPrint("Invite service error: ", error)
                }
            } else {
                completion(false)
                debugPrint("invite service: ", response.result.error!)
            }
        }
    }
    
}
