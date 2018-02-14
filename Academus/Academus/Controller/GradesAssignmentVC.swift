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
    
    var test = [MainOtherAssignments]()
    var filter : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AssignmentService.instance.getOtherAssignmentsForCourse(courseId: filter).count
        //+ AssignmentService.instance.mainUpcomingAssignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OtherAssignmentCell", for: indexPath) as? OtherAssignmentCell {
            cell.configureCell(otherAssignment: AssignmentService.instance.getOtherAssignmentsForCourse(courseId: filter)[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
        
    
    
    
    
    
    
    
    
}
