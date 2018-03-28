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
        navigationItem.title = "Courses"
        tableView.register(CourseCell.self, forCellReuseIdentifier: courseID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewDarkGrey
        
        self.extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)

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
            fetchCourses(token: localToken, completion: { (success) in
                UIView.transition(with: self.tableView, duration: 0.15, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() })
            })
            return
        }

        if courses.isEmpty {
            print("Fetching courses because the token has changed...")
            fetchCourses(token: localToken, completion: { (success) in
                UIView.transition(with: self.tableView,duration: 0.15, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() })
            })
            return
        }
    }
    
    func fetchCourses(token: String, completion: @escaping CompletionHandler) {
        self.courseService.delegate? = self
        courseService.getCourses { (success) in
            if success {
                self.authToken = token
                print("We finished that.")
                completion(true)
            } else {
                completion(false)
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    @objc func refreshTable() {
        self.fetchCourses(token: self.authToken!) { (success) in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (time) in
                self.refreshControl?.endRefreshing()
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                    self.tableView.reloadData()
                })
            })
        }
    }
}
