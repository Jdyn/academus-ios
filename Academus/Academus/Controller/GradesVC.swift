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
    var refreshControl = UIRefreshControl()
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        CourseService.instance.getCourses { (success) in
            self.tableView.reloadData()
            print("GradesVC: Course data loaded onGradesViewLoad")
        }
        
        refreshControl.addTarget(self, action: #selector(GradesVC.refreshData), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)

        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc func refreshData() {
        CourseService.instance.getCourses { (success) in
            self.aTimer()
            print("Data refreshed")
        }
    }
    
    func aTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GradesVC.endOfTimer), userInfo: nil, repeats: true)
    }
    
    @objc func endOfTimer() {
        refreshControl.endRefreshing()
        
        timer.invalidate()
        timer = nil
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseCell {
            cell.configureCell(courses: CourseService.instance.courses[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CourseService.instance.courses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCourseDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "toCourseDetails" {
            let selected = CourseService.instance.courses[(tableView.indexPathForSelectedRow?.row)!].courseID

            if let destination = segue.destination as? GradesAssignmentVC {
                destination.filter = selected!
            }
        }

    }
}
