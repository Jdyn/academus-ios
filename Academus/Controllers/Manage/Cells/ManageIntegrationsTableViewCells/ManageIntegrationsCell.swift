//
//  ManageIntegrationsCell.swift
//  Academus
//
//  Created by Jaden Moore on 3/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageIntegrationsCell: UITableViewCell {
    
    var integration: UserIntegrations? {
        didSet {
            nameLabel.text = integration?.name
            integrationLabel.text = integration?.type
            
            guard let assignedDate = integration?.last_synced else {return}
            let date = timeAgoStringFromDate(date: assignedDate)
            dateLabel.text = "last synced: \(date!)"
            
            if integration?.last_sync_did_error == true {
                circle.backgroundColor = .navigationsRed
            } else {
                circle.backgroundColor = .navigationsGreen
            }
            
            DispatchQueue.global(qos: .background).async {
                let url = URL(string: (self.integration?.icon_url)!)
                guard let data = try? Data(contentsOf: url!) else {return}
                
                DispatchQueue.main.async {
                    self.iconImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = .tableViewLightGrey
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1.5
        view.layer.shadowOpacity = 0.2
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        return view
    }()
    
    let circle: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.size.width/2
        return view
    }()
    
    let syncIcon: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "sync")
        image.tintColor = .navigationsGreen
        return image
    }()
    
    let syncLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 12)
        label.text = "Sync now"
        label.textColor = .navigationsLightGrey
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 12)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let integrationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-demibold", size: 12)
        label.textColor = .navigationsWhite
        return label
    }()
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-medium", size: 12)
        label.textColor = .tableViewPeriodText
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewGrey
        selectionStyle = .none
        
        let stackView = UIStackView(arrangedSubviews: [
            iconImage, nameLabel, dateLabel
            ])
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        addSubview(background)
        addSubview(circle)
        addSubview(stackView)
        addSubview(iconImage)
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(syncLabel)
        addSubview(syncIcon)
        
        background.anchors(top: topAnchor, topPad: 6, bottom: bottomAnchor, bottomPad: 0,left: leftAnchor, leftPad: 6, right: rightAnchor, rightPad: -6,width: 0, height: 0)
        circle.anchors(left: background.leftAnchor, leftPad: 6, centerY: background.centerYAnchor, width: 10, height: 10)
        stackView.anchors(left: circle.rightAnchor, leftPad: 12, centerY: background.centerYAnchor, width: 0, height: 0)
        iconImage.anchors(left: stackView.leftAnchor, centerY: stackView.centerYAnchor ,width: 28, height: 28)
        nameLabel.anchors(top: iconImage.topAnchor, left: iconImage.rightAnchor, leftPad: 6, width: 0, height: 0)
        dateLabel.anchors(bottom: iconImage.bottomAnchor, left: iconImage.rightAnchor, leftPad: 6, width: 0, height: 0)
        syncLabel.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 0, height: 0)
        syncIcon.anchors(right: syncLabel.leftAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 16, height: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
