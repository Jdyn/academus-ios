//
//  OtherAssignmentCell.swift
//  Academus
//
//  Created by Jaden Moore on 2/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class OtherAssignmentCell: UITableViewCell {
    
    @IBOutlet weak var AssignmentTitle: UILabel!
    @IBOutlet weak var AssignmentGrade: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(otherAssignment: MainOtherAssignments) {
        AssignmentTitle.text! = otherAssignment.otherAssignmentName
        AssignmentGrade.text! = otherAssignment.otherAssignmentGrade
    
    }

}
