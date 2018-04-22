//
//  CourseDetailsController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class CourseDetailsController: UITableViewController, AssignmentServiceDelegate {
    
    private let assignmentService = AssignmentService()
    var assignments = [Assignment]()
    var assignmentID = "AssignmentCell"
    var course: Course?
    var courseID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "about"), style: .plain, target: self, action: #selector(handleCourseInfo))
        tableView.separatorColor = .tableViewSeperator
        tableView.separatorStyle = .none
        self.extendedLayoutIncludesOpaqueBars = true

        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
        tableView.register(CourseAssignmentCell.self, forCellReuseIdentifier: assignmentID)
        fetchAssignments()
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    func fetchAssignments() {
        assignmentService.delegate = self
        assignmentService.getAssignments { (success) in
            if success {
                self.tableView.reloadData()
                print("We finished that.")
            } else {
                print("failed to get courses")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: assignmentID, for: indexPath) as! CourseAssignmentCell
        cell.assignment = assignments[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func didGetAssignments(assignments: [Assignment]) {
        let filtered = assignments.filter { $0.course.id == courseID }
        for assignment in filtered {
            self.assignments.append(assignment)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleCourseInfo() {
        let courseInfoController = CourseInfoController(style: .grouped)
        courseInfoController.course = course
        navigationController?.pushViewController(courseInfoController, animated: true)
    }
}
