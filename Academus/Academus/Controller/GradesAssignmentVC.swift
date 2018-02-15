//
//  GradesAssignmentVC.swift
//  Academus
//
//  Created by Jaden Moore on 2/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class GradesAssignmentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    static var instance = GradesAssignmentVC()
    
    var filter : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        AssignmentService.instance.getAssignments { (success) in
            self.tableView.reloadData()
            print("GradesVC: Assignment data loaded onGradesViewLoad")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AssignmentService.instance.getAssignmentsForCourse(courseId: filter).count
        //+ AssignmentService.instance.mainUpcomingAssignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCell", for: indexPath) as? AssignmentCell {
            cell.configureCell(assignment: AssignmentService.instance.getAssignmentsForCourse(courseId: filter)[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    
    
    
    
    
    
    
}

