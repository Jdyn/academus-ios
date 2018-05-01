//
//  AssignmentDetailController.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/25/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

class AssignmentDetailController: UITableViewController {
    
    var assignment: Assignment?
    var card: PlannerCard?
    var cells = [AssignmentDetailCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Assignment Information"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewDarkGrey
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        cells = [.title, .category, .score, .dueDate, .description]
        for cell in cells {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell.getCellType())
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let manager = cellsFiltered[indexPath.row]
        let type = manager.getCellType()
        let cell = tableView.dequeueReusableCell(withIdentifier: type, for: indexPath)
        
        switch manager {
        case .title: return nameCell(manager: manager, cell: cell)
        case .description: return descriptionCell(manager: manager, cell: cell)
        default: return detailCell(manager: manager, cell: cell)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupSection(type: .header)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return setupSection(type: .footer) }
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 18 }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 9 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return section == 0 ? 4 : 1 }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return UITableViewAutomaticDimension }
}

extension AssignmentDetailController {
    
    private func nameCell(manager: AssignmentDetailCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let courseTitle = UILabel().setUpLabel(text: assignment?.course?.name ?? "Unknown Course", font: UIFont.standard!, fontColor: .navigationsWhite)
        let title = UILabel().setUpLabel(text: assignment?.name ?? "Unknown Assignment", font: UIFont.largeHeader!, fontColor: .navigationsGreen)
        title.numberOfLines = 0
        
        cell.addSubviews(views: [background, title, courseTitle])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)

        courseTitle.anchors(top: background.topAnchor, topPad: 6, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor)
        title.anchors(top: courseTitle.bottomAnchor, topPad: 6, bottom: background.bottomAnchor, bottomPad: -9, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9)
        
        return cell
    }
    
    private func detailCell(manager: AssignmentDetailCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: manager.getTitle(), font: UIFont.standard!, fontColor: .navigationsWhite)
        let subtext = UILabel().setUpLabel(text: manager.getSubtext(assignment: assignment, card: card)!, font: UIFont.standard!, fontColor: .navigationsLightGrey)
        subtext.textAlignment = .right
        subtext.numberOfLines = 2
        subtext.adjustsFontSizeToFitWidth = true
        
        switch subtext.text {
        case "Unknown Assignment", "None", "No Score Available":
            subtext.font = UIFont.italic!
            subtext.textColor = .tableViewLightGrey
        default: break
        }
        
        cell.addSubviews(views: [background, subtext, title])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        title.anchors(top: background.topAnchor, topPad: 9, left: background.leftAnchor, leftPad: 12)
        subtext.anchors(left: cell.centerXAnchor, right: background.rightAnchor, rightPad: -12, centerY: title.centerYAnchor)
        
        return cell
    }
    
    private func descriptionCell(manager: AssignmentDetailCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: manager.getTitle(), font: UIFont.standard!, fontColor: .navigationsWhite)
        let subtext = UILabel().setUpLabel(text: manager.getSubtext(assignment: assignment, card: card) ?? "No Description Available", font: UIFont.subheader!, fontColor: .navigationsLightGrey)
        subtext.textAlignment = .left
        subtext.adjustsFontSizeToFitWidth = true
        subtext.numberOfLines = 0
        
        cell.addSubviews(views: [background, title, subtext])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        title.anchors(top: background.topAnchor, topPad: 0, centerX: background.centerXAnchor)
        subtext.anchors(top: title.bottomAnchor, topPad: 9, bottom: background.bottomAnchor, bottomPad: -9, left: background.leftAnchor, leftPad: 12, right: background.rightAnchor, rightPad: -9)
        
        return cell
    }
}
