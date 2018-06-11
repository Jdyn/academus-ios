//
//  CourseDetailsController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class AssignmentsController: UITableViewController {
    
    private let apiService = ApiService()
    private let cellID = "AssignmentCell"
    var assignments = [Assignment]()
    var course: Course?
    var barbutton: Bool = true
    
    var infoButton: UIBarButtonItem?
    var summaryButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = course?.name
        self.extendedLayoutIncludesOpaqueBars = true
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        tableView.register(AssignmentCell.self, forCellReuseIdentifier: cellID)
        
        if barbutton {
            infoButton = UIBarButtonItem(image: #imageLiteral(resourceName: "about"), style: .plain, target: self, action: #selector(handleCourseInfo))
            summaryButton = UIBarButtonItem(image: #imageLiteral(resourceName: "barChart"), style: .plain, target: self, action: #selector(handleCourseSummary))
            if (course?.categories?.count)! <= 0 {
                summaryButton?.isEnabled = false
            }
            navigationItem.rightBarButtonItems = [infoButton!, summaryButton!]
            
            
            Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: { (time) in
                self.tableView.reloadData()
                print("REFREHSED")
            })
        }

        fetchAssignments { (success) in
            if success {
                UIView.transition(with: self.tableView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    @objc func handleCourseSummary() {
        let courseBreakdownController = CourseBreakdownController(style: .grouped)
        courseBreakdownController.course = course
        navigationController?.pushViewController(courseBreakdownController, animated: true)
    }


    
    func fetchAssignments(completion: @escaping CompletionHandler) {
        guard course?.id != nil else {
            alertMessage(title: "Oops", message: "An error has occured. \nIf you encounter this, please contact the chat in the Manage tab.")
            return
        }
        
        apiService.fetchGenericData(url: ApiManager.assignments.getUrl(courseID: course?.id)) { (assignments: [Assignment]?, success, error) in
            if success {
                self.assignments = assignments!
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AssignmentCell
        cell.assignment = assignments[indexPath.row]
        
        if traitCollection.forceTouchCapability == .available { registerForPreviewing(with: self, sourceView: cell) }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignmentDetailController = AssignmentDetailController(style: .grouped)
        assignmentDetailController.assignment = assignments[indexPath.row]
        
        navigationController?.pushViewController(assignmentDetailController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func handleCourseInfo() {
        let courseInfoController = CourseInfoController(style: .grouped)
        courseInfoController.model = course
        navigationController?.pushViewController(courseInfoController, animated: true)
    }
}

extension AssignmentsController: UIViewControllerPreviewingDelegate { // TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return assignments.count }
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 3 }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = previewingContext.sourceView as? AssignmentCell else { return nil }
        previewingContext.sourceRect = cell.background.frame
        
        let assignmentDetailController = AssignmentDetailController(style: .grouped)
        assignmentDetailController.assignment = cell.assignment
        return assignmentDetailController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let controller = viewControllerToCommit as? AssignmentDetailController else { return }
        show(controller, sender: self)
    }
}
