//
//  CollectionPointsCell.swift
//  Academus
//
//  Created by Jaden Moore on 4/29/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CollectionPointsCell: UICollectionViewCell {
    
    let background = UIView().setupBackground(bgColor: .tableViewGrey)
    let category = UILabel().setUpLabel(text: "", font: UIFont.demiStandard!, fontColor: .navigationsWhite)
    let divider = UIView().setupBackground(bgColor: .tableViewLightGrey)
    let points = UILabel().setUpLabel(text: "", font: UIFont.demiStandard!, fontColor: .navigationsWhite)
    let pointsPossible = UILabel().setUpLabel(text: "", font: UIFont.demiStandard!, fontColor: .navigationsGreen)
    let grade = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsGreen)
    let curPercent = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .tableViewLightGrey)
    let totPercent = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .tableViewLightGrey)
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        backgroundColor = .tableViewDarkGrey
//
//        background.backgroundColor = .tableViewMediumGrey
//        background.roundCorners(corners: .all)
//        background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 2.5, opacity: 0.3)
//
//        category.textAlignment = .center
//        category.numberOfLines = 4
//        category.adjustsFontSizeToFitWidth = true
//    }
}
