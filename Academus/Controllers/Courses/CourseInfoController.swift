//
//  CourseInfoController.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

class CourseInfoController: UITableViewController {

    var model: Course?
    var cells: [CourseInfoCellManager] = [.title, .graph]
    
    let topDivider = UIView().setupBackground(bgColor: .navigationsGreen)
    let leftDivider = UIView().setupBackground(bgColor: .navigationsGreen)
    let rightDivider = UIView().setupBackground(bgColor: .navigationsGreen)

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
        case .graph: return UITableViewCell()
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
        label.anchors(top: background.bottomAnchor, topPad: 6, left: background.leftAnchor, leftPad: 13, right: background.rightAnchor, rightPad: -13)
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 18 }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return (section == 2) ? 150 : 9 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
}

extension CourseInfoController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        leftDivider.anchors(top: topDivider.bottomAnchor, left: topDivider.leftAnchor, leftPad: topDivider.frame.width * 1/3, width: 1, height: 52)
        rightDivider.anchors(top: topDivider.bottomAnchor, left: topDivider.leftAnchor, leftPad: topDivider.frame.width * 2/3, width: 1, height: 52)
    }

    private func titleCell(manager: CourseInfoCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none

        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        
        let button = ShareButton(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        button.backgroundColor = .tableViewMediumGrey
        button.setImage(#imageLiteral(resourceName: "email"), for: .normal)
        button.tintColor = .navigationsGreen
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.size.width / 2
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 9.0)
        button.layer.borderWidth = 1.5
        button.setTitleColor(.navigationsGreen, for: .normal)
        button.titleLabel?.font = UIFont.standard
        button.layer.borderColor = UIColor.navigationsGreen.cgColor
        button.email = model?.teacher?.email
        button.addTarget(self, action: #selector(emailPressed), for: .touchUpInside)
        
        topDivider.layer.cornerRadius  = 1
        leftDivider.layer.cornerRadius  = 1
        rightDivider.layer.cornerRadius  = 1

        
        let courseTeacher = UILabel().setUpLabel(text: model?.teacher?.name ?? "", font: UIFont.standard!, fontColor: .navigationsGreen)
        let courseName = UILabel().setUpLabel(text: model?.name ?? "Unknown Course", font: UIFont.largeHeader!, fontColor: .navigationsWhite)
        
        let gradeLabel = UILabel().setUpLabel(text: "\(model?.grade?.letter ?? "")", font: UIFont.subtext!, fontColor: .navigationsGreen)
        let gradeTitleLabel = UILabel().setUpLabel(text: "Grade", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        gradeLabel.font = UIFont(name: "AvenirNext-demibold", size: 48)
        gradeLabel.sizeToFit()
        gradeLabel.textAlignment = .center
        
        let period = UILabel().setUpLabel(text: "\(model?.period ?? 0)", font: UIFont.largeHeader!, fontColor: .navigationsGreen)
        period.textAlignment = .center
        let periodTitle = UILabel().setUpLabel(text: "Period", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        periodTitle.textAlignment = .center

        let roomNumber = UILabel().setUpLabel(text: model?.classroomNumber ?? "?", font: UIFont.largeHeader!, fontColor: .navigationsGreen)
        roomNumber.textAlignment = .center
        let roomTitle = UILabel().setUpLabel(text: "Room", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        roomTitle.textAlignment = .center
        
        let totalStudents = UILabel().setUpLabel(text: "\(model?.totalStudents ?? 0)", font: UIFont.largeHeader!, fontColor: .navigationsGreen)
        totalStudents.textAlignment = .center
        let totalStudentsTitle = UILabel().setUpLabel(text: "Students", font: UIFont.standard!, fontColor: .tableViewLightGrey)
        totalStudentsTitle.numberOfLines = 2
        totalStudentsTitle.textAlignment = .center

        cell.addSubviews(views: [background, gradeLabel, gradeTitleLabel, courseName, courseTeacher, period, roomNumber, totalStudents, topDivider, leftDivider, rightDivider, periodTitle, roomTitle, button, totalStudentsTitle])
        
        courseTeacher.anchors(top: background.topAnchor, topPad: 0, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9)
        courseName.anchors(top: courseTeacher.bottomAnchor, topPad: 0, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9)
        
        topDivider.anchors(top: gradeTitleLabel.bottomAnchor, topPad: 16, left: background.leftAnchor, leftPad: 12, right: background.rightAnchor, rightPad: -12, height: 1)
        gradeLabel.anchors(bottom: background.centerYAnchor, bottomPad: 12, left: background.leftAnchor, leftPad: 12)
        gradeTitleLabel.anchors(top: background.centerYAnchor, left: background.leftAnchor, leftPad: 12)
        
        
        roomNumber.anchors(top: topDivider.bottomAnchor, topPad: 3, left: topDivider.leftAnchor, right: leftDivider.leftAnchor)
        roomTitle.anchors(top: roomNumber.bottomAnchor, topPad: -6, left: topDivider.leftAnchor, right: leftDivider.leftAnchor)

        period.anchors(top: topDivider.bottomAnchor, topPad: 3, left: leftDivider.rightAnchor, right: rightDivider.leftAnchor)
        periodTitle.anchors(top: period.bottomAnchor, topPad: -6, left: leftDivider.rightAnchor, right: rightDivider.leftAnchor)
        
        totalStudents.anchors(top: topDivider.bottomAnchor, topPad: 3, left: rightDivider.rightAnchor, right: topDivider.rightAnchor)
        totalStudentsTitle.anchors(top: period.bottomAnchor, topPad: -6, bottom: background.bottomAnchor, bottomPad: -9, left: rightDivider.rightAnchor, right: topDivider.rightAnchor)
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9, height: 0)

        button.anchors(bottom: gradeTitleLabel.bottomAnchor, bottomPad: -9, right: topDivider.rightAnchor, width: 45, height: 45)

        return cell
    }
    
    @objc func emailPressed(_ sender: ShareButton) {
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
            self.alertMessage(title: "Who?", message: "No email available...")
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
