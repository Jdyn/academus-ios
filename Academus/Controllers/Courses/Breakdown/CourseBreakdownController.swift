//
//  CourseBreakdownController.swift
//  Academus
//
//  Created by Jaden Moore on 4/29/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation


class CourseBreakdownController: UITableViewController {
    
    var course: Course?
    var cells = [CourseBreakdownCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Course Breakdown"
        self.extendedLayoutIncludesOpaqueBars = true
        
        cells = [.title, .total, .points]
        cells.forEach { (cell) in
            if cell == .points {
                tableView.register(CoursePointsCell.self, forCellReuseIdentifier: cell.getCellType())
            } else {
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell.getCellType())
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let manager = cells[indexPath.row]
        let model = self.course!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: manager.getCellType(), for: indexPath)
        
        switch manager {
        case .title: return cell
        case .total: return cell
        case .points:
            let pointsCell = tableView.dequeueReusableCell(withIdentifier: manager.getCellType(), for: indexPath) as! CoursePointsCell
            return pointsCell
        }
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        guard let pointsCell = cell as? CoursePointsCell else { return }
//
//        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
//        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
//    }
}

extension CourseBreakdownController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return course?.categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectCell", for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
    

}

extension CourseBreakdownController {
    
    private func pointsCell(manager: CourseBreakdownCellManager, cell: UITableViewCell) -> UITableViewCell {
        return UITableViewCell()
    }
}
