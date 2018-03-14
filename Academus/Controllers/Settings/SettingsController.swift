//
//  SettingsController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    var cellTypes = [FormCellType]()
    var cellTypesFiltered = [FormCellType]()
    var mediumRowCount: Int = 0
    var smallRowCount: Int = 0
    var largeRowCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellTypes = [.profile, .manageIntegrations, .manageInvites, .settings, .help, .about]
        navigationItem.title = "Manage"
        for type in cellTypes {
            tableView.registerCell(type.cellType().getClass())
            if type.getSection() == 0 {
                largeRowCount += 1
            }
            if type.getSection() == 1 {
                mediumRowCount += 1
            }
            if type.getSection() > 1 {
                smallRowCount += 1
            }
        }
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewLightGrey
//        tableView.alwaysBounceVertical = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                self.cellTypesFiltered = cellTypes.filter { $0.getSection() == indexPath.section }
                let c = cellTypesFiltered[indexPath.row]
                let cellClass = c.cellType().getClass()
                let cell = tableView.dequeueReusableCell(withIdentifier: cellClass.cellReuseIdentifier(), for: indexPath) as! BaseCell
                cell.set(title: c.getTitle(), image: c.image(), subtext: c.getSubtext())
                cell.type = c.cellType()
                return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section >= 1 {
            let view = UIView()
            view.backgroundColor = .tableViewLightGrey
            let divider = UIView()
            divider.backgroundColor = .tableViewSeperator
            view.addSubview(divider)
            divider.anchors(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, width: 0, height: 1)
            return view
//        } else if section == 1{
//            let view = UIView()
//            view.backgroundColor = .tableViewLightGrey
//            return view
        } else {
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
//        if section == 1 {
//            return 8
//        } else if section > 1 {
//            return 16
//        } else {
//            return 0
//        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return largeRowCount
        }
        if section == 1 {
            return mediumRowCount
        } else {
            return smallRowCount
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cells = cellTypesFiltered[indexPath.row]
        return cells.cellType().getHeight()
    }
}
