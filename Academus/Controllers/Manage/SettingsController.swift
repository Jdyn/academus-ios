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

    var cells = [SettingsCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewDarkGrey
        cells = [.appLock, .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous]
        for type in cells {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: type.getCellType())
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let cellAtIndex = cellsFiltered[indexPath.row]
        let cellType = cellAtIndex.getCellType()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        
        switch cellAtIndex {
        case .appLock: return biometricsCell(c: cellAtIndex, cell: cell)
        case .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous:
            return notificationCell(c: cellAtIndex, cell: cell)
        default: return UITableViewCell()
        }
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
        let view = UIView().setupBackground(bgColor: .tableViewDarkGrey)
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .navigationsGreen)
        
        let sections: [SettingsCellManager] = [.privacySecurity, .notifications ]
        let item = sections[section]
        
        switch item {
        case .privacySecurity: title.text = item.getTitle()
        case .notifications: title.text = item.getTitle()
        default: title.text = ""
        }
        
        view.addSubviews(views: [background, title])
        
        background.anchors(top: view.topAnchor, topPad: 9, bottom: view.bottomAnchor, bottomPad: 9, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        title.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor)
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 33 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return(section == 0 ? 1 : 3) }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        return cellsFiltered[indexPath.row].getHeight()
    }
}

extension SettingsController {
    
    private func notificationCell(c: SettingsCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.subheader!, fontColor: .navigationsWhite)
        let icon = UIImageView().setupImageView(color: .navigationsGreen, image: c.getImage())
        
        let toggle = UISwitch()
        toggle.thumbTintColor = .navigationsWhite
        toggle.onTintColor = .navigationsGreen
        toggle.tintColor = .navigationsWhite
        toggle.addTarget(self, action: #selector(didToggle), for: .valueChanged)
        
        cell.addSubviews(views: [background, icon, title, toggle])
            
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        toggle.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.setState(toggle: toggle)
        })
        
        return cell
    }
    
    private func biometricsCell(c: SettingsCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.subheader!, fontColor: .navigationsWhite)
        
        let icon = UIImageView()
        icon.image = c.getImage()
        icon.tintColor = .navigationsGreen
        
        let toggle = UISwitch()
        toggle.thumbTintColor = .navigationsWhite
        toggle.onTintColor = .navigationsGreen
        toggle.tintColor = .navigationsWhite
        toggle.addTarget(self, action: #selector(didToggle), for: .valueChanged)
        
        cell.addSubviews(views: [background, icon, title, toggle])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        toggle.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.setState(toggle: toggle)
        })
        
        return cell
    }
    
    func setState(toggle: UISwitch) {
        if let superview = toggle.superview {
            for view in superview.subviews {
                if let title = view as? UILabel {
                    switch title.text {
                    case SettingsCellManager.appLock.getTitle():
                        toggle.setOn(UserDefaults.standard.bool(forKey: SettingsBundleKeys.appLockPreference), animated: false)
                        break
                    case SettingsCellManager.notifAssignmentPosted.getTitle():
                        toggle.setOn(UserDefaults.standard.bool(forKey: SettingsBundleKeys.assignmentPostedPreference), animated: false)
                    case SettingsCellManager.notifCourseGradeUpdated.getTitle():
                        toggle.setOn(UserDefaults.standard.bool(forKey: SettingsBundleKeys.courseGradePostedPreference), animated: false)
                    case SettingsCellManager.notifMiscellaneous.getTitle():
                        toggle.setOn(UserDefaults.standard.bool(forKey: SettingsBundleKeys.miscPreference), animated: false)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    @objc func didToggle(_ sender: UISwitch) {
        if let superview = sender.superview {
            for view in superview.subviews {
                if let title = view as? UILabel {
                    switch title.text {
                    case SettingsCellManager.appLock.getTitle():
                        UserDefaults.standard.set(sender.isOn, forKey: SettingsBundleKeys.appLockPreference)
                        break
                    case SettingsCellManager.notifAssignmentPosted.getTitle():
                        UserDefaults.standard.set(sender.isOn, forKey: SettingsBundleKeys.assignmentPostedPreference)
                    case SettingsCellManager.notifCourseGradeUpdated.getTitle():
                        UserDefaults.standard.set(sender.isOn, forKey: SettingsBundleKeys.courseGradePostedPreference)
                    case SettingsCellManager.notifMiscellaneous.getTitle():
                        UserDefaults.standard.set(sender.isOn, forKey: SettingsBundleKeys.miscPreference)
                    default:
                        break
                    }
                }
            }
        }
    }
}

