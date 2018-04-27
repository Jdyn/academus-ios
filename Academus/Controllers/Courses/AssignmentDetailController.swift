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
    var cells = [AssignmentDetailCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Assignment Information"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewDarkGrey
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        cells = [.name, .course, .score, .dueDate, .description]
        for cell in cells {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: cell.getCellType())
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let cellAtIndex = cellsFiltered[indexPath.row]
        let cellType = cellAtIndex.getCellType()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        
        return detailCell(c: cellAtIndex, cell: cell)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView().setupBackground(bgColor: .tableViewDarkGrey)
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsGreen)
        
        let sections: [AssignmentDetailCellManager] = [.header]
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return setupSection(type: .footer) }
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 50 }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableViewAutomaticDimension }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 18 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 5 }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat { return UITableViewAutomaticDimension }
}

extension AssignmentDetailController {
    private func detailCell(c: AssignmentDetailCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.subheader!, fontColor: .navigationsWhite)
        let subtext = UILabel()
        subtext.textAlignment = .left
        subtext.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        subtext.numberOfLines = 0
        
        if c.getSubtext(assignment: assignment)?.isEmpty == false {
            subtext.text = c.getSubtext(assignment: assignment)
            subtext.font = UIFont.subheader!
            subtext.textColor = .navigationsLightGrey
        } else {
            subtext.text = c.getAltSubtext()
            subtext.font = UIFont.italic!
            subtext.textColor = .tableViewLightGrey
        }
        
        cell.addSubviews(views: [background, title, subtext])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        title.anchors(top: background.topAnchor, topPad: 9, left: background.leftAnchor, leftPad: 12)
        subtext.anchors(top: background.topAnchor, topPad: 9, left: background.centerXAnchor, leftPad: -21, right: background.rightAnchor, rightPad: -12, centerY: background.centerYAnchor)
        
        return cell
    }
}
