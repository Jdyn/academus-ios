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
    
    var courses = [Course]()
    let courseID = "courseCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("courses view did load")
        navigationItem.title = "Courses"
        courseService.delegate = self
        tableView.register(CourseCell.self, forCellReuseIdentifier: courseID)
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.tableViewSeperator
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        courseService.getCourses { (success) in
            if success {
                self.tableView.reloadData()
            } else {
                print("failed to get courses")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if courses.isEmpty {
            courseService.getCourses { (success) in
                if success {
                    self.tableView.reloadData()
                } else {
                    print("failed to get courses")
                }
            }
        }
    }

    func didGetCourses(courses: [Course]) {
        print("course delegate triggered")
        self.courses.removeAll()
        for course in courses {
            self.courses.append(course)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: courseID, for: indexPath) as! CourseCell
        
        let course = self.courses[indexPath.row]
        cell.course = course
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseDetailsController = CourseDetailsController()
        courseDetailsController.navigationItem.title = courses[indexPath.row].name
        courseDetailsController.courseID = courses[indexPath.row].id
        
        navigationController?.pushViewController(courseDetailsController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
