//
//  coursesController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class CoursesController: UITableViewController {
    
    private let integrationService = IntegrationService()
    private let apiService = ApiService()
    private let cellID = "courseCell"
    
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Courses"
        extendedLayoutIncludesOpaqueBars = true
        tableView.register(CourseCell.self, forCellReuseIdentifier: cellID)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        tableView.separatorStyle = .none
        
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        fetchCourses { (success, error)  in
            if success {
                UIView.transition(with: self.tableView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                    self.tableView.reloadData()
                })
            } else {
                self.tableViewEmptyLabel(message: error, show: true)
            }
        }
    }
    
    func integrationCheck() {
        
    }
    
    func fetchCourses(completion: @escaping (_ success: Bool, _ error: String?) -> ()) {
        
        apiService.fetchGenericData(url: ApiManager.courses.getUrl()) { (courses: [Course]?, success, error) in
            if success {
                self.courses.removeAll()
                self.courses = courses!
                if self.courses.isEmpty { self.integrationCheck() }
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    @objc func refresh() {
        fetchCourses { (success, error)  in
            if success {
                self.tableViewEmptyLabel(show: false)
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (time) in
                    self.refreshControl?.endRefreshing()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                        self.tableView.reloadData()
                        if self.courses.isEmpty { self.integrationCheck() }
                    })
                })
            } else {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (time) in
                    self.refreshControl?.endRefreshing()
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                        self.alertMessage(title: "Could not refresh :(", message: error!)
                    })
                })
            }
        }
    }
}

extension CoursesController: UIViewControllerPreviewingDelegate { // TableView & Preview Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return courses.count }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 90 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CourseCell
        
        if traitCollection.forceTouchCapability == .available { registerForPreviewing(with: self, sourceView: cell) }
        let course = self.courses[indexPath.row]
        cell.course = course
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseDetailsController = AssignmentsController()
        courseDetailsController.course = courses[indexPath.row]
        
        navigationController?.pushViewController(courseDetailsController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = previewingContext.sourceView as? CourseCell else { return nil }
        previewingContext.sourceRect = cell.background.frame
        
        guard let indexPath = tableView.indexPath(for: cell) else { return nil }
        
        if (courses[indexPath.row].categories?.count)! > 0 {
            let courseBreakdownController = CourseBreakdownController(style: .grouped)
            courseBreakdownController.course = cell.course
            return courseBreakdownController
        } else {
            let courseInfoController = CourseInfoController(style: .grouped)
            courseInfoController.model = cell.course
            return courseInfoController
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        let controller = viewControllerToCommit
        show(controller, sender: self)
    }
}
