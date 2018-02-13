//
//  GradesVC.swift
//  Academus
//
//  Created by Jaden Moore on 2/9/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GradesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    static var instance = GradesVC()
    var mainCourse = [MainCourse]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        self.getCourses { (success) in
            print(success)
            self.tableView.reloadData()
        }
    }
    
    func getCourses(completion: @escaping CompletetionHandler) {
        Alamofire.request(URL_COURSE!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            guard let data = response.data else {return}
            if response.result.error == nil {
                do {
                    
                    let courses = try JSONDecoder().decode(Courses.self, from: data)
                    
                    for eachCourse in courses.result {
                        let name = eachCourse.name
                        let letter = eachCourse.grade.letter
                        let grade = eachCourse.grade.percent
                        let period = String(eachCourse.period)
                        let aCourse = MainCourse(courseName: name, courseLetter: letter, coursePercent: grade, coursePeriod: period)
                        self.mainCourse.append(aCourse)
                        
                    }
                    
                } catch let error {
                    debugPrint(error)
                }
                completion(true)
            } else {
                
                completion(false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseCell {
            cell.configureCell(mainCourse: mainCourse[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainCourse.count
    }
    

}
