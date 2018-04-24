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
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
        setupChatButtonInNavBar()
        
        self.extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        if courses.isEmpty {
            fetchCourses(completion: { (success) in
                if success {
                    self.errorLabel(show: false)
                    UIView.transition(with: self.tableView,duration: 0.1, options: .transitionCrossDissolve, animations: {
                        self.tableView.reloadData()
                        if self.courses.isEmpty {
                            self.addIntegrationLabel(show: true)
                        }
                    })
                } else {
                    self.errorLabel(show: true)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if self.courses.isEmpty && self.tableView.backgroundView == nil {
                self.loadingAlert(title: "Loading Courses", message: "This will take just a moment...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.refreshTable()
//                    print(self.courses)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        })
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
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)).setUpLabel(text: "Oops... :( \nCheck your Internet connection and refresh", font: UIFont.standard!, fontColor: .navigationsLightGrey)
        label.textAlignment = .center
        label.numberOfLines = 0
        if show {
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
    }
    
    func addIntegrationLabel(show: Bool) {
        let bgView = UIView()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)).setUpLabel(text: "You don't have any courses!", font: UIFont.standard!, fontColor: .navigationsLightGrey)
        label.textAlignment = .center
        label.numberOfLines = 0
        let button = UIButton().setUpButton(title: "Get Started", font: UIFont.standard!, fontColor: .navigationsGreen)
        button.addTarget(self, action: #selector(addIntegration), for: .touchUpInside)
        
        bgView.addSubviews(views: [label, button])
        label.anchors(centerX: bgView.centerXAnchor, centerY: bgView.centerYAnchor)
        button.anchors(top: label.bottomAnchor, topPad: 6, centerX: bgView.centerXAnchor)
        
        if show {
            tableView.backgroundView = bgView
        } else {
            tableView.backgroundView = nil
        }
    }
    
    @objc func addIntegration() {
        let controller = IntegrationSelectController()
        navigationController?.pushViewController(controller, animated: true)
        tableView.backgroundView = nil
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
        courseDetailsController.course = courses[indexPath.row]
        courseDetailsController.courseID = courses[indexPath.row].id
        
        navigationController?.pushViewController(courseDetailsController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return courses.count }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 90 }
    
    @objc func refreshTable() {
        fetchCourses() { (success) in
            if success {
                self.errorLabel(show: false)
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (time) in
                    self.refreshControl?.endRefreshing()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                        self.tableView.reloadData()
                        if self.courses.isEmpty {
                            self.addIntegrationLabel(show: true)
                        }
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
