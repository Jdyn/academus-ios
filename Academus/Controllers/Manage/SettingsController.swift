//
//  SettingsController.swift
//  Academus
//
//  Created by Jaden Moore on 3/15/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class SettingsController: UITableViewController {

    var cellType = [SettingsCellTypes]()
    var cells = [SettingsCells]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewGrey
        
        cellType = [.mediumCell, .smallCell]
        cells = [.fingerPrintLock, .NotifAssignmentPosted, .NotifCourseGradeUpdated, .NotifMiscellaneous]
        for type in cells {
            tableView.registerCell(type.cellType().getClass())
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        let c = cellsFiltered[indexPath.row]
        let cellClass = c.cellType().getClass()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellClass.cellReuseIdentifier(), for: indexPath) as! SettingsBaseCell
        cell.set(title: c.getTitle(), image: c.image(), subtext: c.getSubtext())
        cell.type = c.cellType()
        cell.index = indexPath.row
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
        let view = UIView()
        view.backgroundColor = .tableViewGrey
        
        let background = UIView()
        background.backgroundColor = .tableViewLightGrey
        
        let title = UILabel()
        title.textColor = .navigationsGreen
        title.font = UIFont(name: "AvenirNext-medium", size: 14)
        if section == 0 {
            title.text = "Privacy and Security"
        }
        if section == 1 {
            title.text = "Notifications"
        }
        
        view.addSubview(background)
        view.addSubview(title)
        
        background.anchors(top: view.topAnchor, topPad: 9, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6, width: 0, height: 0)
        title.anchors(top: background.topAnchor, topPad: 3, left: background.leftAnchor, leftPad: 6, width: 0, height: 0)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
//        
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].rowCount()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellType[indexPath.section].getHeight()
    }
}
