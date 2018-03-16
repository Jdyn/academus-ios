//
//  SmallCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class SmallCell: BaseCell {
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
<<<<<<< HEAD
        view.layer.shadowOffset = CGSize.zero//(width: 1, height: 1)
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = 0.2
=======
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.3
>>>>>>> d321d897c6b5f1da3a9c180d1a961186bc97cf20
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 14)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let icon: UIImageView = {
        let view = UIImageView()
<<<<<<< HEAD
        view.tintColor = .navigationsLightGrey
=======
        view.tintColor = .tableViewSeperator
>>>>>>> d321d897c6b5f1da3a9c180d1a961186bc97cf20
        return view
    }()
    
    override func setTitle(title: String) {
        self.title.text = title
    }
    
    override func setImage(image: UIImage) {
        self.icon.image = image
    }
    
    
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
<<<<<<< HEAD
        backgroundColor = .tableViewGrey
=======
        backgroundColor = .tableViewLightGrey
>>>>>>> d321d897c6b5f1da3a9c180d1a961186bc97cf20
        selectionStyle = .none

        addSubview(background)
        addSubview(icon)
        addSubview(title)
        
<<<<<<< HEAD
        background.anchors(top: topAnchor, topPad: 4, bottom: bottomAnchor, bottomPad: -4, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -16, width: 0, height: 0)
=======
        background.anchors(top: topAnchor, topPad: 0, bottom: bottomAnchor, bottomPad: -6, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6, width: 0, height: 0)
>>>>>>> d321d897c6b5f1da3a9c180d1a961186bc97cf20
        icon.anchors(left: background.leftAnchor, leftPad: 12, centerY: background.centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 18, centerY: background.centerYAnchor, width: 0, height: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
