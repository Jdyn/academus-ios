//
//  CourseDetailsController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class CourseDetailsController: UITableViewController, UIViewControllerPreviewingDelegate, AssignmentServiceDelegate {
    
    private let assignmentService = AssignmentService()
    var assignments = [Assignment]()
    var assignmentID = "AssignmentCell"
    var course: Course?
    var courseID : Int?
    var barbutton: Bool = true
    
    var infoButton: UIBarButtonItem?
    var summaryButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .tableViewSeperator
        tableView.separatorStyle = .none
        self.extendedLayoutIncludesOpaqueBars = true
        if barbutton {
            infoButton = UIBarButtonItem(image: #imageLiteral(resourceName: "about"), style: .plain, target: self, action: #selector(handleCourseInfo))
            summaryButton = UIBarButtonItem(image: #imageLiteral(resourceName: "barChart"), style: .plain, target: self, action: #selector(handleCourseSummary))
            if (course?.categories?.count)! <= 0 {
                summaryButton?.isEnabled = false
            }
            navigationItem.rightBarButtonItems = [infoButton!, summaryButton!]
        }
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
        tableView.register(CourseAssignmentCell.self, forCellReuseIdentifier: assignmentID)
        fetchAssignments()
    }
    
    @objc func handleCourseSummary() {
        let courseBreakdownController = CourseBreakdownController(style: .grouped)
        courseBreakdownController.course = course
        navigationController?.pushViewController(courseBreakdownController, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    func fetchAssignments() {
        assignmentService.delegate = self
        assignmentService.getAssignments(courseID: courseID!) { (success) in
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
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: cell)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignmentDetailController = AssignmentDetailController(style: .grouped)
        assignmentDetailController.assignment = assignments[indexPath.row]
        
        navigationController?.pushViewController(assignmentDetailController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = previewingContext.sourceView as? CourseAssignmentCell else { return nil }
        previewingContext.sourceRect = cell.background.frame
        
        let assignmentDetailController = AssignmentDetailController(style: .grouped)
        assignmentDetailController.assignment = cell.assignment
        return assignmentDetailController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let controller = viewControllerToCommit as? AssignmentDetailController else { return }
        show(controller, sender: self)
    }
    
    
    func didGetAssignments(assignments: [Assignment]) {
        let filtered = assignments.filter { $0.course?.id == courseID }
        for assignment in filtered {
            self.assignments.append(assignment)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleCourseInfo() {
        let courseInfoController = CourseInfoController(style: .grouped)
        courseInfoController.model = course
        navigationController?.pushViewController(courseInfoController, animated: true)
    }
}
