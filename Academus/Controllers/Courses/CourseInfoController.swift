//
//  CourseInfoController.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import Charts

class CourseInfoController: UITableViewController {

    var model: Course?
    var cells: [CourseInfoCellManager] = [.title, .graph]
    var graph: BarChartView!
    let impact = UIImpactFeedbackGenerator()
    
    let topDivider = UIView().setupBackground(bgColor: .navigationsGreen)
    let leftDivider = UIView().setupBackground(bgColor: .navigationsGreen)
    let rightDivider = UIView().setupBackground(bgColor: .navigationsGreen)
    let bottomDivider = UIView().setupBackground(bgColor: .navigationsGreen)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Course Information"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewDarkGrey
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200.0
        self.extendedLayoutIncludesOpaqueBars = true
        
        cells.forEach { (cell) in
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell.getCellType())
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let manager = cellsFiltered[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: manager.getCellType(), for: indexPath)
        
        switch manager {
        case .title: return titleCell(manager: manager, cell: cell)
        case .graph: return graphCell(manager: manager, cell: cell)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupSection(type: .header)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 1 else { return setupSection(type: .footer) }
        
        let view = UIView()
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let label = UILabel().setUpLabel(text: "These statistics are an estimate — the more students in this class that use Academus, the more accurate they will be.", font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        
        label.numberOfLines = 3
        background.roundCorners(corners: .bottom)
        view.addSubviews(views: [background, label])
        
        background.anchors(top: view.topAnchor, left: view.leftAnchor, leftPad: 8, right: view.rightAnchor, rightPad: -8, height: 9)
        label.anchors(top: background.bottomAnchor, topPad: 6, left: background.leftAnchor, leftPad: 12, right: background.rightAnchor, rightPad: -12)
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 18 }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return (section == 1) ? 100 : 9 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
}

extension CourseInfoController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        leftDivider.anchors(top: topDivider.bottomAnchor, left: topDivider.leftAnchor, leftPad: topDivider.frame.width * 1/3, width: 2, height: 50)
        rightDivider.anchors(top: topDivider.bottomAnchor, left: topDivider.leftAnchor, leftPad: topDivider.frame.width * 2/3, width: 2, height: 50)
        bottomDivider.anchors(top: rightDivider.bottomAnchor, left: topDivider.leftAnchor, right: topDivider.rightAnchor, height: 2)
    }

    private func titleCell(manager: CourseInfoCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none

        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        
        let button = ShareButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        button.backgroundColor = .tableViewMediumGrey
        button.setImage(#imageLiteral(resourceName: "email"), for: .normal)
        button.tintColor = .navigationsWhite
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.size.width / 2
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 9.0)
        button.layer.borderWidth = 2
        button.setTitleColor(.navigationsGreen, for: .normal)
        button.titleLabel?.font = UIFont.standard
        button.layer.borderColor = UIColor.navigationsGreen.cgColor
        button.email = model?.teacher?.email
        button.addTarget(self, action: #selector(emailPressed), for: .touchUpInside)
        
        topDivider.layer.cornerRadius  = 1
        leftDivider.layer.cornerRadius  = 1
        rightDivider.layer.cornerRadius  = 1

        let courseTeacher = UILabel().setUpLabel(text: model?.teacher?.name ?? "", font: UIFont.standard!, fontColor: .navigationsGreen)
        let courseName = UILabel().setUpLabel(text: model?.name ?? "Course", font: UIFont.largeHeader!, fontColor: .navigationsWhite)
        let gradeLabel = UILabel().setUpLabel(text: "\(model?.grade?.letter ?? "")", font: UIFont.subtext!, fontColor: .navigationsGreen)
        let gradeTitle = UILabel().setUpLabel(text: "Grade", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        gradeLabel.font = UIFont(name: "AvenirNext-demibold", size: 48)
        gradeLabel.sizeToFit()
        gradeLabel.textAlignment = .right

        let period = UILabel().setUpLabel(text: "\(model?.period ?? 0)", font: UIFont.header!, fontColor: .navigationsWhite)
        period.textAlignment = .center
        let periodTitle = UILabel().setUpLabel(text: "Period", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        periodTitle.textAlignment = .center

        let roomNumber = UILabel().setUpLabel(text: model?.classroomNumber ?? "?", font: UIFont.header!, fontColor: .navigationsWhite)
        roomNumber.textAlignment = .center
        let roomTitle = UILabel().setUpLabel(text: "Room", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        roomTitle.textAlignment = .center
        
        let totalStudents = UILabel().setUpLabel(text: "\(model?.totalStudents ?? 0)", font: UIFont.header!, fontColor: .navigationsWhite)
        totalStudents.textAlignment = .center
        let totalStudentsTitle = UILabel().setUpLabel(text: "Students", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        totalStudentsTitle.numberOfLines = 2
        totalStudentsTitle.textAlignment = .center

        cell.addSubviews(views: [background, gradeLabel, gradeTitle, courseName, courseTeacher, period, roomNumber, totalStudents, topDivider, bottomDivider, leftDivider, rightDivider, periodTitle, roomTitle, button, totalStudentsTitle])
        
        courseTeacher.anchors(top: background.topAnchor, topPad: 0, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9)
        courseName.anchors(top: courseTeacher.bottomAnchor, topPad: 0, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9)
        topDivider.anchors(top: gradeTitle.bottomAnchor, topPad: 16, left: background.leftAnchor, leftPad: 12, right: background.rightAnchor, rightPad: -12, height: 2)
        gradeLabel.anchors(top: courseName.bottomAnchor, topPad: 0, left: background.leftAnchor, leftPad: 14)
        gradeTitle.anchors(top: gradeLabel.bottomAnchor, topPad: -9, left: background.leftAnchor, leftPad: 12)

        roomNumber.anchors(top: topDivider.bottomAnchor, topPad: 3, left: topDivider.leftAnchor, right: leftDivider.leftAnchor)
        roomTitle.anchors(top: roomNumber.bottomAnchor, topPad: -6, left: topDivider.leftAnchor, right: leftDivider.leftAnchor)

        period.anchors(top: topDivider.bottomAnchor, topPad: 3, left: leftDivider.rightAnchor, right: rightDivider.leftAnchor)
        periodTitle.anchors(top: period.bottomAnchor, topPad: -6, left: leftDivider.rightAnchor, right: rightDivider.leftAnchor)
        
        totalStudents.anchors(top: topDivider.bottomAnchor, topPad: 3, left: rightDivider.rightAnchor, right: topDivider.rightAnchor)
        totalStudentsTitle.anchors(top: period.bottomAnchor, topPad: -6, bottom: background.bottomAnchor, bottomPad: -16, left: rightDivider.rightAnchor, right: topDivider.rightAnchor)
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9, height: 0)

        button.anchors(right: background.rightAnchor, rightPad: -24, centerY: background.centerYAnchor, CenterYPad: -9, width: 48, height: 48)

        return cell
    }

    private func graphCell(manager: CourseInfoCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.selectionStyle = .none
        cell.backgroundColor = .tableViewDarkGrey
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let graphTitle = UILabel().setUpLabel(text: "Course Grade Statistics", font: UIFont.standard!, fontColor: .navigationsGreen)
        let chartIcon = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "chart"))
        
        graph = BarChartView()
        graph.legend.enabled = false
        graph.rightAxis.drawLabelsEnabled = false
        graph.rightAxis.drawGridLinesEnabled = false
        graph.rightAxis.drawZeroLineEnabled = false
        
        graph.gridBackgroundColor = .clear
        graph.isUserInteractionEnabled = false
        
        graph.xAxis.drawGridLinesEnabled = false
        
        guard
            let highest = model?.highestGrade,
            let you = model?.grade?.percent,
            let average = model?.averageGrade,
            let lowest = model?.lowestGrade
        else {
            graph.noDataText = "No Data Available"
            cell.addSubviews(views: [background, graph])
            background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
            graph?.anchors(top: background.topAnchor, bottom: background.bottomAnchor, bottomPad: -12, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9, height: 300)
            return cell
        }
        
        let data = [highest, you, average, lowest]
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<data.count {
            let entry = BarChartDataEntry(x: Double(i), y: Double(data[i]))
            dataEntries.append(entry)
        }
        
        let xLabels = ["Highest", "You", "Average", "Lowest"]
        graph.xAxis.valueFormatter = IndexAxisValueFormatter(values: xLabels)
        graph.xAxis.labelPosition = .bottom
        graph.xAxis.granularityEnabled = true
        graph.chartDescription = nil
        graph.xAxis.labelCount = 4
        graph.xAxis.labelFont = UIFont.subtext!
        graph.xAxis.labelTextColor = .navigationsWhite
        
        graph.leftAxis.axisMinimum = 0
        graph.leftAxis.axisMaximum = 100
        graph.leftAxis.labelCount = 5
        graph.leftAxis.drawZeroLineEnabled = false
        graph.leftAxis.labelFont = UIFont.small!
        graph.leftAxis.labelTextColor = .navigationsWhite

        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1
        formatter.percentSymbol = "%"
        
        let array: [NSUIColor] = [
            NSUIColor(cgColor: UIColor.navigationsLightGrey.cgColor),
            NSUIColor(cgColor: UIColor.navigationsGreen.cgColor),
            NSUIColor(cgColor: UIColor.navigationsLightGrey.cgColor),
            NSUIColor(cgColor: UIColor.navigationsLightGrey.cgColor)
        ]
        
        let dataSet = BarChartDataSet(values: dataEntries, label: "test")
        dataSet.colors = array
        dataSet.valueTextColor = .navigationsWhite
        dataSet.valueFont = UIFont.subtext!
        
        let barGraph = BarChartData(dataSet: dataSet)
        barGraph.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        graph?.data = barGraph

        cell.addSubviews(views: [background, graph, graphTitle, chartIcon])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        chartIcon.anchors(top: background.topAnchor, left: background.leftAnchor, leftPad: 9, width: 24, height: 24)
        graphTitle.anchors(left: chartIcon.rightAnchor, leftPad: 6, centerY: chartIcon.centerYAnchor)

        graph.anchors(top: graphTitle.bottomAnchor, topPad: 9, bottom: background.bottomAnchor, bottomPad: -9, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9, height: 200)
        graph.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        return cell
    }
    
    @objc func emailPressed(_ sender: ShareButton) {
        impact.impactOccurred()
        if sender.email != nil {
            let alert = UIAlertController(title: "Email Teacher", message: "Are you sure you want to open up mail?", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
                guard let email = sender.email else { return }
                if let url = NSURL(string: "mailto:\(email)") {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            
            let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(actionNo)
            alert.addAction(actionYes)
            present(alert, animated: true, completion: nil)
            
        } else {
            self.alertMessage(title: "Who?", message: "There is no email available for your teacher.")
        }
    }
}

enum CourseInfoCellManager {
    case title
    case graph
    
    func getSection() -> Int {
        switch self {
        case .title: return 0
        case .graph: return 1
        }
    }
    
    func getCellType() -> String {
        switch self {
        case .title: return "titleCell"
        case .graph: return "graphCell"
        }
    }
}
