//
//  CourseBreakdownController.swift
//  Academus
//
//  Created by Jaden Moore on 4/29/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Charts

class CourseBreakdownController: UITableViewController {
    
    var course: Course?
    var cells = [CourseBreakdownCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Grade Breakdown"
        self.extendedLayoutIncludesOpaqueBars = true
        
        cells = [.title, .total, .points]
        cells.forEach { (cell) in
            if cell == .points {
                tableView.register(CoursePointsCell.self, forCellReuseIdentifier: cell.getCellType())
            } else {
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell.getCellType())
            }
        }
        
        setupChart()
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
    
    func setupChart() {
        guard let categoryCount = course?.categories?.count, categoryCount > 1 else { return }
        
        let actualCats = course?.categories?.filter { $0.name != "TOTAL" }
        let dataSet = PieChartDataSet(values: actualCats?.map { PieChartDataEntry(value: $0.weightAsDouble(), label: $0.truncatedName()) }, label: "")
        dataSet.colors = ChartColorTemplates.pastel() + ChartColorTemplates.colorful().reversed()
        dataSet.valueTextColor = .white
        dataSet.valueFont = UIFont.subheader!
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1
        formatter.percentSymbol = "%"
        
        let chartData = PieChartData(dataSet: dataSet)
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        let pieChart = PieChartView()
        pieChart.data = chartData
        pieChart.drawEntryLabelsEnabled = false
        pieChart.chartDescription?.enabled = false
        pieChart.legend.enabled = true
        pieChart.legend.font = UIFont.small!
        pieChart.legend.orientation = .vertical
        pieChart.legend.verticalAlignment = .center
        pieChart.legend.horizontalAlignment = .right
        pieChart.legend.direction = .rightToLeft
        pieChart.legend.textColor = .white
        pieChart.legend.yEntrySpace = 7
        print(pieChart.legend.calculatedLabelSizes)
        pieChart.holeColor = .clear
        
        view.addSubview(pieChart)
        pieChart.anchors(top: tableView.bottomAnchor, topPad: 180, left: view.leftAnchor, right: view.rightAnchor, centerX: view.centerXAnchor, height: 300)
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
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
