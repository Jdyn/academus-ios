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
            title.text = integration?.name
            
            DispatchQueue.global(qos: .background).async {
                let url = URL(string: (self.integration?.icon_url)!)
                guard let data = try? Data(contentsOf: url!) else {return}
                
                DispatchQueue.main.async {
                    self.icon.image = UIImage(data: data)
                }
            }
        }
    }
    
    let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
    let title = UILabel().setUpLabel(text: "", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
    let icon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
        
        addSubviews(views: [background, icon, title])
        
        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 16, centerY: background.centerYAnchor, width: 32, height: 32)
        title.anchors(left: icon.rightAnchor, leftPad: 16, centerY: background.centerYAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
