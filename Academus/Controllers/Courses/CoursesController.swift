//
//  coursesController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CoursesController: UITableViewController, CourseServiceDelegate {
    
    private let courseService = CourseService()
    
    var course = [Course]()
    let courseID = "courseCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("courses controller view did load")
        navigationItem.title = "Courses"
        courseService.delegate = self
        
        tableView.register(CourseCell.self, forCellReuseIdentifier: courseID)
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.tableViewSeperator
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            if (course.isEmpty) {
                courseService.getCourses { (success) in
                    if success {
                        self.tableView.reloadData()
                    } else {
                        print("failed to get courses")
                    }
                }
            }
    }

    func didGetCourses(courses: CourseModel) {
        self.course.removeAll()
        for course in courses.result {
            self.course.append(course)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: courseID, for: indexPath) as! CourseCell
        
        let course = self.course[indexPath.row]
        cell.course = course
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseDetailsController = CourseDetailsController()
        courseDetailsController.navigationItem.title = course[indexPath.row].name
        courseDetailsController.courseID = course[indexPath.row].id
        
        navigationController?.pushViewController(courseDetailsController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
