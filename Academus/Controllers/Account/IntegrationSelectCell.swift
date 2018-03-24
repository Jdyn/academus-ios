//
//  GetIntegrationCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class IntegrationSelectCell: UITableViewCell {
    
    var integration: IntegrationChoice? {
        didSet {
            nameLabel.text = integration?.name
            let url = URL(string: (integration?.icon_url)!)
            let data = try? Data(contentsOf: url!)
            iconImage.image = UIImage(data: data!)
        }
    }
    
    let cellBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewMediumGrey
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = 0.2
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 16)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        addSubview(cellBackground)
        addSubview(iconImage)
        addSubview(nameLabel)
        
        cellBackground.anchors(top: topAnchor, topPad: 3, bottom: bottomAnchor, bottomPad: -3,left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6,width: 0, height: 0)
        iconImage.anchors(left: cellBackground.leftAnchor, leftPad: 16, centerY: cellBackground.centerYAnchor ,width: 32, height: 32)
        nameLabel.anchors(left: iconImage.rightAnchor, leftPad: 16, centerY: cellBackground.centerYAnchor,width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
