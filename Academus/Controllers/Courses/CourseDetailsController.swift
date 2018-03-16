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
    var authToken: String?
    var courseID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
=======
 
>>>>>>> d321d897c6b5f1da3a9c180d1a961186bc97cf20
        tableView.separatorColor = .tableViewSeperator
        tableView.separatorStyle = .none
        tableView.register(CourseAssignmentCell.self, forCellReuseIdentifier: assignmentID)
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) else {return}
        self.authToken = (dictionary["authToken"] as? String ?? "")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
        setupScrollingNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        assignmentService.delegate = self
        guard let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) else {return}
        let localToken = (dictionary["authToken"] as? String ?? "")
        
        if localToken != self.authToken {
            print("Fetching courses because the token has changed...")
            self.fetchAssignments(token: localToken)
            return
        }
        
        if assignments.isEmpty {
            print("Fetching assignments because the list is empty...")
            self.fetchAssignments(token: localToken)
            return
        }
    }
    
    func fetchAssignments(token: String) {
        assignmentService.getAssignments { (success) in
            if success {
                self.authToken = token
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
        return 85
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
}
