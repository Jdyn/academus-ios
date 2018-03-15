//
//  LargeCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class LargeCell: BaseCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 14)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let subtext: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-light", size: 12)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let icon: UIImageView = {
        let view = UIImageView()
        view.tintColor = .tableViewSeperator
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
        selectionStyle = .none
        addSubview(icon)
        addSubview(title)
        addSubview(subtext)
        
        icon.anchors(top: topAnchor, topPad: 12, left: leftAnchor, leftPad: 12, width: 48, height: 48)
        title.anchors(top: icon.bottomAnchor, bottomPad: 3, left: leftAnchor, leftPad: 12, width: 0, height: 0)
        subtext.anchors(top: title.bottomAnchor, topPad: 0, left: leftAnchor, leftPad: 12, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
