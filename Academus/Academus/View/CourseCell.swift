//
//  CourseCell.swift
//  Academus
//
//  Created by Jaden Moore on 2/11/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseGrade: UILabel!
    @IBOutlet weak var coursePercent: UILabel!
    @IBOutlet weak var coursePeriod: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(mainCourse : MainCourse) {
        courseName.text! = mainCourse.courseName
        coursePeriod.text! = mainCourse.coursePeriod
        courseGrade.text! = mainCourse.courseLetter
        coursePercent.text! = "(\(round(mainCourse.coursePercent))%)"
    }
}
