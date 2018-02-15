//
//  AssignmentCell.swift
//  Academus
//
//  Created by Jaden Moore on 2/14/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class AssignmentCell: UITableViewCell {

    @IBOutlet weak var assignmentGrade: UILabel!
    @IBOutlet weak var assignmentTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(assignment : Assignment) {
        assignmentGrade.text! = assignment.assignmentGrade
        assignmentTitle.text! = assignment.assignmentName
    }
}
