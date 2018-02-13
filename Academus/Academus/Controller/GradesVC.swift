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
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.decelerationRate = UIScrollViewDecelerationRateNormal
        
        self.getCourses { (success) in
            print(success)
            self.tableView.reloadData()
        }
        refreshControl.addTarget(self, action: #selector(GradesVC.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
//        refreshControl.attributedTitle = NSAttributedString(string: "What text should I put here", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc func refreshData() {
        self.getCourses { (success) in
            self.aTimer()
            //self.refreshControl.endRefreshing()
            print(true)
        }
    }
    
    func aTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GradesVC.endOfTimer), userInfo: nil, repeats: true)
    }
    
    @objc func endOfTimer() {
        refreshControl.endRefreshing()
        
        timer.invalidate()
        timer = nil
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
