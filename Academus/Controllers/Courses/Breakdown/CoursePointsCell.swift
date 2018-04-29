//
//  CoursePointsCell.swift
//  Academus
//
//  Created by Jaden Moore on 4/29/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class CoursePointsCell: UITableViewCell {
    
    fileprivate weak var collectionView: UICollectionView!

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
        
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}
