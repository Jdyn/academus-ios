//
//  PlannerCell.swift
//  Academus
//
//  Created by Jaden Moore on 2/15/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class PlannerCell: UITableViewCell {

    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(name : String, number : String) {
        taskName.text! = name
        taskNumber.text! =  number
    }
}
