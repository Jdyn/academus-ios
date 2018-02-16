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

class CourseVC: UITableViewController {
    
    static var instance = CourseVC()
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CourseService.instance.getCourses { (success) in
            self.tableView.reloadData()
            print("GradesVC: Course data loaded onGradesViewLoad")
        }
        AssignmentService.instance.getAssignments { (success) in
            print("GradesVC: Assignment data loaded onGradesViewLoad")
        }
        
        refreshControl?.addTarget(self, action: #selector(self.refreshData), for: UIControlEvents.valueChanged)
        refreshControl?.tintColor = UIColor.white
        refreshControl?.backgroundColor = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
    }
    
    @objc func refreshData() {
        CourseService.instance.courses.removeAll()
        CourseService.instance.getCourses { (success) in
            self.tableView.reloadData()
            self.aTimer()
        }
    }
    
    func aTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.endOfTimer), userInfo: nil, repeats: true)
    }
    
    @objc func endOfTimer() {
        refreshControl?.endRefreshing()
        timer.invalidate()
        timer = nil
//        var indexPathsToReload = [IndexPath]()
//        for course in CourseService.instance.courses.indices {
//            let indexPath = IndexPath(item: course, section: 0)
//            indexPathsToReload.append(indexPath)
//            print(course)
//        }
//        self.tableView.reloadRows(at: indexPathsToReload, with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as? CourseCell {
            cell.configureCell(courses: CourseService.instance.courses[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CourseService.instance.courses.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCourseDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCourseDetails" {
            let selected = CourseService.instance.courses[(tableView.indexPathForSelectedRow?.row)!].courseID
            if let destination = segue.destination as? CourseDetailsVC {
                destination.filter = selected!
            }
        }

    }
}
