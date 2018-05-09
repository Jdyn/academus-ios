//
//  CoursePointsCell.swift
//  Academus
//
//  Created by Jaden Moore on 4/29/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CourseCollectionCell: UITableViewCell { //, UICollectionViewDelegate, UICollectionViewDataSource
    
    var collection: UICollectionView!
    var background: UIView!
    
//    var collectionViewOffset: CGFloat {
//        set { collection.contentOffset.x = newValue }
//        get { return collection.contentOffset.x }
//    }
    
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collection.delegate = dataSourceDelegate
        collection.dataSource = dataSourceDelegate
        collection.tag = row
        collection.setContentOffset(collection.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collection.reloadData()
        layoutIfNeeded()
        print("FROM CELL DELEGATE", collection.contentSize as Any)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tableViewDarkGrey
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
