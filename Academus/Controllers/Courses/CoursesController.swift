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
    var label: UILabel?
    
    var courses = [Course]()
    private let cellId = "courseCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Courses"
        tableView.register(CourseCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 41, 0)
        
        setupChatButtonInNavBar()
        
        self.extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        if courses.isEmpty {
            fetchCourses(completion: { (success) in
                if success {
                    UIView.transition(with: self.tableView,duration: 0.1, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() })
                    self.errorLabel(show: false)
                } else {
                    self.errorLabel(show: true)
                }
            })
        }
     }

    func fetchCourses(completion: @escaping CompletionHandler) {
        print("Fetching Courses...")
        courseService.delegate = self
        courseService.getCourses { (success) in
            if success {
                print("We finished that.")
                completion(true)
            } else {
                print("failed to get courses")
                completion(false)
            }
        }
    }
    
    func errorLabel(show: Bool) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height)).setUpLabel(text: "Oops... :( \nCheck your Internet connection and refresh", font: UIFont.standard!, fontColor: .navigationsLightGrey)
        label.textAlignment = .center
        label.numberOfLines = 0
        if show {
            self.tableView.backgroundView = label
        } else {
            self.tableView.backgroundView = nil
        }
    }
    
    func didGetCourses(courses: [Course]) {
        print("Initiating Course Protocol...")
        self.courses.removeAll()
        for course in courses {
            self.courses.append(course)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CourseCell
        let course = self.courses[indexPath.row]
        cell.course = course
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseDetailsController = CourseDetailsController()
        courseDetailsController.navigationItem.title = courses[indexPath.row].name
        courseDetailsController.courseID = courses[indexPath.row].id
        
        navigationController?.pushViewController(courseDetailsController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return courses.count }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 90 }
    
    @objc func refreshTable() {
        self.fetchCourses() { (success) in
            if success {
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (time) in
                    self.refreshControl?.endRefreshing()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                        self.tableView.reloadData()
                    })
                })
            } else {
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (time) in
                    self.refreshControl?.endRefreshing()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                        self.alertMessage(title: "Could not refresh :(", message: "Check your internet connection and try again")
                    })
                })
            }
        }
    }
}
