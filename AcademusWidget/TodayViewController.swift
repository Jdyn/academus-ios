//
//  TodayViewController.swift
//  AcademusWidget
//
//  Created by Pasha Bouzarjomehri on 4/30/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NotificationCenter

typealias CompletionHandler = (_ Success: Bool) -> ()

class TodayViewController: UIViewController, NCWidgetProviding {
    var shared = UserDefaults(suiteName: "group.academus")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        CFPreferencesAppSynchronize(kCFPreferencesAnyApplication)
        
        if getCourses() != nil {
            let label = UILabel()
            label.text = "works"
            view.addSubview(label)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func getCourses() -> [Course]? {
        print(shared)
        print(shared?.string(forKey: "authToken"))
        print(shared?.string(forKey: "BASE_URL"))
        
        guard let authToken = shared?.string(forKey: "authToken"),
            let BASE_URL = shared?.string(forKey: "BASE_URL") else { return nil }
        
        var courses = [Course]()
        Alamofire.request(URL(string: "\(BASE_URL)/api/courses?token=\(authToken)")!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else { return }
            if response.result.error == nil {
                do {
                    let json = JSON(data)
                    let jsonResult = try json["result"].rawData()
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let course = try decoder.decode([Course].self, from: jsonResult)
                    if json["success"] == true {
                        courses = course
                    }
                } catch let error{
                    debugPrint(error)
                }
            } else {
                debugPrint(response.result.error as Any)
            }
        }
        
        return courses
    }
}
