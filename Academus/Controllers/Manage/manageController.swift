//
//  manageController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class manageController: UITableViewController {

    var cellType = [CellType]()
    var cells = [FormCellType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Manage"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewLightGrey
        
        cellType = [.largeCell, .mediumCell, .smallCell]
        cells = [.profile, .manageIntegrations, .manageInvites, .settings, .help, .about]
        for type in cells {
            tableView.registerCell(type.cellType().getClass())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellsFiltered = cells.filter { $0.cellType().getSection() == indexPath.section }
        let c = cellsFiltered[indexPath.row]
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
        } else {
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellsFiltered = cells.filter { $0.cellType().getSection() == indexPath.section }
        print(cellsFiltered[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType[section].getRowCount()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellType[indexPath.section].getHeight()
    }
}
