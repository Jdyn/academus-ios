//
//  CourseInfoController.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/20/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

class CourseInfoController: UITableViewController {

    var course: Course?
    var cells = [CourseInfoCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Course Information"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewDarkGrey
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)

        self.extendedLayoutIncludesOpaqueBars = true
        
        cells = [.courseName, .customName, .period, .classroomNumber, .teacherName, .email, .total, .average, .highest, .lowest]
        for cell in cells {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell.getCellType())
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let cellAtIndex = cellsFiltered[indexPath.row]
        let cellType = cellAtIndex.getCellType()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        
        return infoCell(c: cellAtIndex, cell: cell)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView().setupBackground(bgColor: .tableViewDarkGrey)
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsGreen)
        
        let sections: [CourseInfoCellManager] = [.courseInfo, .teacherInfo, .statsInfo]
        let item = sections[section]
        title.text = item.getTitle()
        
        background.roundCorners(corners: .top)

        let icon = UIImageView()
        icon.image = item.getImage()
        icon.tintColor = .navigationsGreen
        
        view.addSubviews(views: [background, icon, title])
        
        background.anchors(top: view.topAnchor, topPad: 9, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor, width: 24, height: 24)
        title.anchors(left: icon.rightAnchor, leftPad: 9, centerY: background.centerYAnchor)
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 2 else { return setupSection(type: .footer) }
        
        let view = UIView()
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let label = UILabel().setUpLabel(text: "These statistics are an estimate — the more students in this class that use Academus, the more accurate they will be.", font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        
        label.numberOfLines = 0
        background.roundCorners(corners: .bottom)
        view.addSubviews(views: [background, label])
        
        background.anchors(top: view.topAnchor, left: view.leftAnchor, leftPad: 5, right: view.rightAnchor, rightPad: -5, height: 9)
        label.anchors(top: background.bottomAnchor, topPad: 6, left: background.leftAnchor, leftPad: 13, right: background.rightAnchor, rightPad: -13)
        return view
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 3 }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 50 }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 44 }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return (section == 2) ? 150 : 18 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return (section == 1) ? 2 : 4 }
}

extension CourseInfoController {
    private func infoCell(c: CourseInfoCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.subheader!, fontColor: .navigationsWhite)
        let subtext = UILabel()
        subtext.textAlignment = .right
        
        if c.getSubtext(course: course)?.isEmpty == false {
            subtext.text = c.getSubtext(course: course)
            subtext.font = UIFont.subheader!
            subtext.textColor = .navigationsLightGrey
        } else {
            subtext.text = c.getAltSubtext()
            subtext.font = UIFont.italic!
            subtext.textColor = .tableViewLightGrey
        }
        subtext.adjustsFontSizeToFitWidth = true
        cell.addSubviews(views: [background, title, subtext])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        title.anchors(top: background.topAnchor, topPad: 9, left: background.leftAnchor, leftPad: 12, centerY: background.centerYAnchor)
        subtext.anchors(top: background.topAnchor, topPad: 9, left: title.rightAnchor, leftPad: 12, right: background.rightAnchor, rightPad: -12, centerY: title.centerYAnchor)

        return cell
    }
}
