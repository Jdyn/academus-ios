//
//  CourseDetails.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/22/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CourseDetailsController: UITableViewController{
    
    let course = CoursesController().course
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButtonInNavBar()
    }
}
