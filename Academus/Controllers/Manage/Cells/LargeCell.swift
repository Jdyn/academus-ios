//
//  LargeCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

protocol CustomCellDelegate {
    func cellButtonTapped(cell: BaseCell)
}

class LargeCell: BaseCell {
    
    var delegate: CustomCellDelegate?
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 14)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let subtext: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-light", size: 12)
        label.textColor = .navigationsLightGrey
        return label
    }()
    
    let icon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .navigationsLightGrey
        return view
    }()
        
    override func setTitle(title: String) {
        self.title.text = title
    }
    
    override func setImage(image: UIImage) {
        self.icon.image = image
    }
    
    override func setSubtext(text: String) {
        self.subtext.text = text
    }
    
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewGrey
<<<<<<< HEAD
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.4
        layer.shouldRasterize = true
        layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
=======
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowRadius = 3
//        layer.shadowOpacity = 0.4
//        layer.shouldRasterize = true
//        layer.rasterizationScale = true ? UIScreen.main.scale : 1
>>>>>>> d321d897c6b5f1da3a9c180d1a961186bc97cf20
        selectionStyle = .none
        addSubview(icon)
        addSubview(title)
        addSubview(subtext)

        icon.anchors(left: leftAnchor, leftPad: 6, centerY: centerYAnchor, width: 48, height: 48)
        title.anchors(bottom: subtext.topAnchor, left: icon.rightAnchor, leftPad: 6, width: 0, height: 0)
        subtext.anchors(bottom: icon.bottomAnchor, left: icon.rightAnchor, leftPad: 6, width: 0, height: 0)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
