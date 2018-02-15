//
//  IntegrationCell.swift
//  Academus
//
//  Created by Jaden Moore on 2/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class IntegrationCell: UITableViewCell {

    @IBOutlet weak var integrationName: UILabel!
    
    @IBOutlet weak var myImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(integration : Integration) {
        integrationName.text! = integration.integrationName
        let url = URL(string: integration.integrationIcon)
        let data = try? Data(contentsOf: url!)
        myImageView.image = UIImage(data: data!)
    }
}

