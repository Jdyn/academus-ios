//
//  CourseDetailsController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CourseDetailsController: UITableViewController, AssignmentServiceDelegate {
    
    private let assignmentService = AssignmentService()
    var assignments = [Assignment]()
    var assignmentID = "AssignmentCell"
    var courseID : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignmentService.delegate = self
        assignmentService.getAssignments { (succes) in
            self.tableView.reloadData()
        }
        
        tableView.separatorColor = UIColor.tableViewSeperator
        tableView.separatorStyle = .none
        tableView.register(CourseAssignmentCell.self, forCellReuseIdentifier: assignmentID)

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
        return 75
    }
    
    func didGetAssignments(assignments: [Assignment]) {
        
        let filtered = assignments.filter { $0.course.id == courseID }
        for assignment in filtered {
            self.assignments.append(assignment)
        }
    }
    
}
