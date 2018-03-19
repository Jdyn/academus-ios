//
//  coursesController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class CoursesController: UITableViewController, CourseServiceDelegate {
    
    private let courseService = CourseService()
    var authToken: String?
    
    var courses = [Course]()
    let courseID = "courseCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hidesBarsOnSwipe = false
        navigationItem.title = "Courses"
        tableView.register(CourseCell.self, forCellReuseIdentifier: courseID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewGrey

        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) else {return}
        self.authToken = (dictionary["authToken"] as? String ?? "")
     }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        courseService.delegate = self
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) else {return}
        let localToken = (dictionary["authToken"] as? String ?? "")
        
        if localToken != self.authToken {
            print("Fetching courses because the token has changed...")
            self.fetchCourses(token: localToken)
            return
        }
        
        if courses.isEmpty {
            print("Fetching courses because the list is empty...")
            self.fetchCourses(token: localToken)
            return
        }
    }
    
    func fetchCourses(token: String) {
        courseService.getCourses { (success) in
            if success {
                self.authToken = token
                self.tableView.reloadData()
                print("We finished that.")
            } else {
                print("failed to get courses")
            }
        }
    }
    
    func didGetCourses(courses: [Course]) {
        print("Calling courses protocol...")
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
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("what")
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
