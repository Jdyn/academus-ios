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
        navigationItem.title = "Summary"
        self.extendedLayoutIncludesOpaqueBars = true
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        cells = [.title, .total, .points]
        cells.forEach { (cell) in
            if cell == .points {
                tableView.register(CourseCollectionCell.self, forCellReuseIdentifier: cell.getCellType())
            } else {
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell.getCellType())
            }
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }

        switch cellsFiltered[indexPath.row] {
        case .points: return 235
        case .total: return 185
        default: return 65
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return setupSection(type: .header) }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 18  }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 9 }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return setupSection(type: .footer) }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let manager = cellsFiltered[indexPath.row]
        
        switch manager {
        case .points:
            let model = self.course!
            let cell = tableView.dequeueReusableCell(withIdentifier: manager.getCellType(), for: indexPath) as! CourseCollectionCell
            cell.collection = collectionView(cell: cell, model: model)
            cell.collection.register(CollectionPointsCell.self, forCellWithReuseIdentifier: "collectCell")
            return cell
        case .total:
            let categories = course?.categories?.filter { $0.name == "TOTAL" }
            let model = categories![0]
            let cell = tableView.dequeueReusableCell(withIdentifier: manager.getCellType(), for: indexPath)
            return totalCell(cell: cell, model: model)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: manager.getCellType(), for: indexPath)
            let model = course!
            return nameCell(model: model, cell: cell)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let pointsCell = cell as? CourseCollectionCell else { return }
        
        pointsCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        pointsCell.collectionViewOffset = 0
    }
}

extension CourseBreakdownController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categories = course?.categories?.filter { $0.name != "TOTAL" }
        
        let model = categories![indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectCell", for: indexPath) as! CollectionPointsCell
        return pointsCell(model: model, cell: cell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (course?.categories?.count)! - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }

}

extension CourseBreakdownController {
    
    private func nameCell(model: Course, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let name = UILabel().setUpLabel(text: model.teacher?.name ?? "Unknown Teacher", font: UIFont.standard!, fontColor: .navigationsGreen)
        let title = UILabel().setUpLabel(text: model.name ?? "Unknown Course", font: UIFont.largeHeader!, fontColor: .navigationsWhite)
        title.numberOfLines = 0
        
        cell.addSubviews(views: [background, name, title])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        name.anchors(top: background.topAnchor, topPad: 0, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor)
        title.anchors(top: name.bottomAnchor, topPad: 0, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9)
        
        return cell
    }
    
    func totalCell(cell: UITableViewCell, model: Course.Category) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        
        let category = UILabel().setUpLabel(text: model.name!, font: UIFont.demiStandard!, fontColor: .navigationsWhite)
        let divider = UIView().setupBackground(bgColor: .tableViewLightGrey)
        let divider1 = UIView().setupBackground(bgColor: .tableViewLightGrey)

        let points = UILabel().setUpLabel(text: model.points!, font: UIFont.header!, fontColor: .navigationsWhite)
        let pointsPossible = UILabel().setUpLabel(text: model.pointsPossible!, font: UIFont.header!, fontColor: .navigationsGreen)
        
        let pointsPossible1 = UILabel().setUpLabel(text: model.pointsPossible!, font: UIFont.largeHeader!, fontColor: .navigationsGreen)
        let pointsPossible1Subtext = UILabel().setUpLabel(text: "Total Points", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        
        let grade = UILabel().setUpLabel(text: "\(model.weightedGradeLetter!)", font: UIFont.subtext!, fontColor: .navigationsGreen)
        grade.font = UIFont(name: "AvenirNext-demibold", size: 48)
        let gradeSubtext = UILabel().setUpLabel(text: "Grade", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        
        let curPercent = UILabel().setUpLabel(text: model.weightedPercent!, font: UIFont.header!, fontColor: .navigationsWhite)
        curPercent.adjustsFontSizeToFitWidth = true
        curPercent.textAlignment = .center

        let totPercent = UILabel().setUpLabel(text: model.weight!, font: UIFont.header!, fontColor: .navigationsGreen)
        totPercent.adjustsFontSizeToFitWidth = true
        totPercent.textAlignment = .center

        let pointsSubtext = UILabel().setUpLabel(text: "Points", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        let percentSubtext = UILabel().setUpLabel(text: "Percent", font: UIFont.standard!, fontColor: .tableViewLightGrey)

        
        cell.addSubviews(views: [background, category, points, pointsPossible, grade, gradeSubtext, curPercent, totPercent, pointsPossible1, pointsPossible1Subtext, divider, pointsSubtext, percentSubtext, divider1])

        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        
        grade.anchors(top: background.topAnchor, topPad: 0, left: background.leftAnchor, leftPad: 9)
        gradeSubtext.anchors(top: grade.bottomAnchor, topPad: -16, left: background.leftAnchor, leftPad: 9)
        
        pointsPossible1.anchors(top: gradeSubtext.bottomAnchor, topPad: 9, left: background.leftAnchor, leftPad: 9)
        pointsPossible1Subtext.anchors(top: pointsPossible1.bottomAnchor, topPad: -8, left: background.leftAnchor, leftPad: 9)

        pointsSubtext.anchors(top: background.topAnchor, right: background.rightAnchor, rightPad: -24)
        points.anchors(top: pointsSubtext.bottomAnchor, topPad: 0, centerX: pointsSubtext.centerXAnchor)
        divider.anchors(top: points.bottomAnchor, topPad: 0, centerX: pointsSubtext.centerXAnchor, width: 64, height: 2)
        pointsPossible.anchors(top: divider.bottomAnchor, topPad: 0, centerX: pointsSubtext.centerXAnchor)
        
        percentSubtext.anchors(top: pointsPossible.bottomAnchor, topPad: 12, centerX: pointsSubtext.centerXAnchor)
        curPercent.anchors(top: percentSubtext.bottomAnchor, topPad: 0, left: divider1.leftAnchor, right: divider1.rightAnchor)
        divider1.anchors(top: curPercent.bottomAnchor, topPad: 0, centerX: pointsSubtext.centerXAnchor, width: 64, height: 2)
        totPercent.anchors(top: divider1.bottomAnchor, topPad: 0, left: divider1.leftAnchor, right: divider1.rightAnchor)


        return cell
    }
    
    func pointsCell(model: Course.Category, cell: CollectionPointsCell) -> CollectionPointsCell {
        
        cell.backgroundColor = .tableViewMediumGrey
        cell.category.text = model.name ?? "Unknown"
        cell.points.text = model.points ?? "N/A"
        cell.pointsPossible.text = model.pointsPossible ?? "N/A"
        cell.curPercent.text = "(\(model.weightedPercent ?? "N/A"))"
        cell.totPercent.text = "(\(model.weight ?? "N/A"))"
        cell.grade.text = model.weightedGradeLetter ?? "N/A"
        
        cell.curPercent.textAlignment = .center
        cell.totPercent.textAlignment = .center
        
        cell.category.baselineAdjustment = .alignBaselines
        cell.category.numberOfLines = 3
        cell.category.adjustsFontSizeToFitWidth = true
        cell.category.textAlignment = .center
        
        cell.category.preferredMaxLayoutWidth = 95
        cell.background.roundCorners(corners: .all)
        cell.background.setUpShadow(color: .black, offset: CGSize(width: 0, height: 0), radius: 4, opacity: 0.2)
        
        cell.points.adjustsFontSizeToFitWidth = true
        cell.pointsPossible.adjustsFontSizeToFitWidth = true
        cell.points.textAlignment = .center
        cell.pointsPossible.textAlignment = .center

        cell.addSubviews(views: [cell.background, cell.category, cell.divider, cell.points, cell.pointsPossible, cell.curPercent, cell.totPercent, cell.grade])
        
        cell.category.anchors(top: cell.topAnchor, centerX: cell.centerXAnchor)
        cell.background.anchors(top: cell.category.bottomAnchor, topPad: 3, bottom: cell.bottomAnchor, bottomPad: -9, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9, width: 90, height: 148)

        cell.curPercent.anchors(top: cell.background.topAnchor, topPad: 6, centerX: cell.points.centerXAnchor)
        
        cell.grade.anchors(top: cell.curPercent.bottomAnchor, topPad: -3, centerX: cell.points.centerXAnchor)
        
        cell.points.anchors(bottom: cell.divider.topAnchor, bottomPad: -3, left: cell.background.leftAnchor, leftPad: 3, right: cell.background.rightAnchor, rightPad: -3, centerX: cell.background.centerXAnchor)
        cell.divider.anchors(left: cell.background.leftAnchor, leftPad: 9, right: cell.background.rightAnchor, rightPad: -9, centerY: cell.background.centerYAnchor, height: 2)
        cell.pointsPossible.anchors(top: cell.divider.bottomAnchor, topPad: 3, left: cell.background.leftAnchor, leftPad: 3, right: cell.background.rightAnchor, rightPad: -3, centerX: cell.background.centerXAnchor)
        
        cell.totPercent.anchors(bottom: cell.background.bottomAnchor, bottomPad: -6, left: cell.background.leftAnchor, leftPad: 3, right: cell.background.rightAnchor, rightPad: -3, centerX: cell.pointsPossible.centerXAnchor)
        return cell
    }
    
    func collectionView(cell: CourseCollectionCell, model: Course) -> UICollectionView {
        var collection: UICollectionView

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.scrollDirection = .horizontal
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        
        collection = UICollectionView(frame: cell.bounds, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .tableViewMediumGrey
        
        cell.addSubviews(views: [background, collection])
        
        background.anchors(top: cell.topAnchor, topPad: 0, bottom: cell.bottomAnchor, bottomPad: 0, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        collection.anchors(top: background.topAnchor, topPad: 0, bottom: background.bottomAnchor, bottomPad: 0, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9)

        return collection
    }
}
