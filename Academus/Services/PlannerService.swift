//
//  PlannerService.swift
//  Academus
//
//  Created by Jaden Moore on 4/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith

protocol PlannerCardDelegate {
    func didGetPlannerCards(cards: [PlannerCard])
}

class PlannerService {
    
    var delegate: PlannerCardDelegate?
    
    func getPlannerCards(completion: @escaping CompletionHandler) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        let authToken = dictionary?[AUTH_TOKEN]
        
        Alamofire.request(URL(string: "\(BASE_URL)/api/feed?token=\(authToken ?? "")")!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in

            guard let data = response.data else { return }
            if response.result.error == nil {
                
                do {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let json = JSON(data)
                    let jsonResult = try json["result"].rawData()
                    let plannerCards = try decoder.decode([PlannerCard].self, from: jsonResult)
                    self.delegate?.didGetPlannerCards(cards: plannerCards)
                    completion(true)
                } catch let error {
                    completion(false)
                    print(error)
                }
            } else {
                completion(false)
                print(response.result.error as Any)
            }
        }
    }
}
