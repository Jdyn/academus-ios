//
//  manageController.swift
//  SwiftData
//
//  Created by Jaden Moore on 2/18/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class ManageController: UITableViewController {
    
    var cellType = [CellType]()
    var cells = [FormCellType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Manage"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewGrey
        
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
        if cell.type == .largeCell {
            let button = UIButton(type: .system)
            button.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
            button.addTarget(self, action: #selector(handleSignout), for: .touchUpInside)
            button.tintColor = .navigationsRed
            cell.addSubview(button)
            button.anchors(bottom: cell.bottomAnchor, bottomPad: -6, right: cell.rightAnchor, rightPad: -6, width: 0, height: 0)
        }
        return cell
    }
    
    @objc func handleSignout() {
        
        let alert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            self.tabBarController?.selectedIndex = 0
            if Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) != nil {
                do {
                    try Locksmith.deleteDataForUserAccount(userAccount: USER_AUTH)
                } catch let error {
                    debugPrint("could not delete locksmith data:", error)
                }
                let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
                self.present(welcomeNavigationController, animated: true, completion: nil)
            }
        }
        
        let actionNo = UIAlertAction(title: "No", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= 1 {
            let view = UIView()
            view.backgroundColor = .tableViewGrey
            return view
        } else {
            return UIView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 3
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellsFiltered = cells.filter { $0.cellType().getSection() == indexPath.section }

        if cellsFiltered[indexPath.row] == .manageIntegrations {
            let manageIntegrationsController = ManageIntegrationsController()
            navigationController?.pushViewController(manageIntegrationsController, animated: true)
        }
        
        if cellsFiltered[indexPath.row] == .settings {
            let settingsController = SettingsController()
            navigationController?.pushViewController(settingsController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType[section].getRowCount()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellType[indexPath.section].getHeight()
    }
}
