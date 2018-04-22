//
//  SettingsController.swift
//  Academus
//
//  Created by Jaden Moore on 3/15/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith
import UserNotifications
import LocalAuthentication

enum BiometricType {
    case none
    case touchID
    case faceID
}

class SettingsController: UITableViewController {

    var cells = [SettingsCellManager]()
    var notifDictionary = Dictionary<String, Any>()
    var notificationService = NotificationService()
    var didChange: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        tableView.separatorStyle = .none
        tableView.backgroundColor = .tableViewDarkGrey
        self.extendedLayoutIncludesOpaqueBars = true

        cells = [.appLock, .notifSettings, .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous]
        for type in cells {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: type.getCellType())
        }
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_NOTIF)
        notifDictionary = dictionary!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationService().patchNotificationState(didChange: didChange) { (success) in
            if success {
                print ("success")
            } else {
                print("failure")
            }
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
        case .notifSettings: return notificationSettingsCell(c: cellAtIndex, cell: cell)
        default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 44 }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView().setupBackground(bgColor: .tableViewDarkGrey)
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsGreen)
        let subtext = UILabel().setUpLabel(text: "", font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        
        let sections: [SettingsCellManager] = [.privacySecurity, .notifications ]
        let item = sections[section]

        switch item {
        case .privacySecurity: title.text = item.getTitle();
        case .notifications: title.text = item.getTitle()
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    DispatchQueue.main.async(execute: { subtext.text = "" })
                } else {
                    DispatchQueue.main.async(execute: { subtext.text = "" })
                }
            }
        default: title.text = ""
        }

        background.roundCorners(corners: .top)

        view.addSubviews(views: [background, title, subtext])

        background.anchors(top: view.topAnchor, topPad: 9, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        title.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor)
        subtext.anchors(left: title.rightAnchor, leftPad: 0, centerY: background.centerYAnchor)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 18
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return setupSection(type: .footer)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return(section == 0 ? 1 : 4) }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        return cellsFiltered[indexPath.row].getHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        switch cellsFiltered[indexPath.row] {
        case .notifSettings:
            print("SELECTED")
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
    
}
    
extension SettingsController {
    
    private func notificationSettingsCell(c: SettingsCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.standard!, fontColor: .navigationsWhite)
        let icon = UIImageView().setupImageView(color: .navigationsGreen, image: c.getImage())
        let subtext = UILabel().setUpLabel(text: c.getSubtext(), font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        let arrow = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "arrowRight"))
        subtext.numberOfLines = 2
        subtext.lineBreakMode = .byWordWrapping
        background.roundCorners(corners: .bottom)
        
        let subBackground = UIView().setupBackground(bgColor: .navigationsMediumGrey)
        subBackground.roundCorners(corners: .bottom)
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async(execute: {
                    subtext.text = "Fully customize your notification experience and how you want to see them."
                })
            } else {
                DispatchQueue.main.async(execute: {
                    subtext.text = "Enable notifications to recieve the full experience with grade updates and more."
                })
            }
        }
        
        cell.addSubviews(views: [background, subBackground, title, icon, subtext, arrow])
        
        background.anchors(top: cell.topAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6, height: 55)
        subBackground.anchors(top: background.bottomAnchor, bottom: cell.bottomAnchor, bottomPad: -6, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor, width: 24, height: 24)
        arrow.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 32, height: 32)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: background.centerYAnchor)
        subtext.anchors(top: subBackground.topAnchor, topPad: 6, left: subBackground.leftAnchor, leftPad: 6, right: subBackground.rightAnchor, rightPad: -6)
        
        let selectionView = UIView()
        selectionView.backgroundColor = .tableViewDarkGrey
        
        let backgroundView = UIView()
        backgroundView.backgroundColor =  UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 0.1)
        backgroundView.roundCorners(corners: .bottom)
        
        selectionView.addSubview(backgroundView)
        
        backgroundView.anchors(top: selectionView.topAnchor, left: selectionView.leftAnchor, leftPad: 6, right: selectionView.rightAnchor, rightPad: -6, height: 55)
        
        cell.selectedBackgroundView = selectionView
        
        return cell
    }
    
    private func notificationCell(c: SettingsCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.standard!, fontColor: .navigationsWhite)
        let icon = UIImageView().setupImageView(color: .navigationsGreen, image: c.getImage())
        let subtext = UILabel().setUpLabel(text: c.getSubtext(), font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        
        let toggle = notifSwitch()
        toggle.thumbTintColor = .navigationsWhite
        toggle.onTintColor = .navigationsGreen
        toggle.tintColor = .navigationsWhite
        toggle.cellType = c
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_NOTIF)
        switch c {
        case .notifAssignmentPosted: toggle.isOn = dictionary?[isAssignmentsPosted] as! Bool; background.roundCorners(corners: .top)
        case .notifCourseGradeUpdated: toggle.isOn = dictionary?[isCoursePosted] as! Bool
        case .notifMiscellaneous: toggle.isOn = dictionary?[isMisc] as! Bool
        default: break
        }
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async(execute: {
                    toggle.isEnabled = true
                    toggle.addTarget(self, action: #selector(self.didToggle), for: .valueChanged)
                })
            } else {
                DispatchQueue.main.async(execute: {
                    toggle.isEnabled = false
                })
            }
        }
        
        cell.addSubviews(views: [background, icon, title, toggle, subtext])
            
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 24, height: 24)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        toggle.anchors(right: background.rightAnchor, rightPad: -9, centerY: background.centerYAnchor)
        subtext.anchors(top: title.bottomAnchor, left: icon.rightAnchor, leftPad: 12)
        
        return cell
    }
    
    private func biometricsCell(c: SettingsCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsWhite)
        let subtext = UILabel().setUpLabel(text: c.getSubtext(), font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        
        let icon = UIImageView()
        icon.image = c.getImage()
        icon.tintColor = .navigationsGreen
        
        if biometricType() == .touchID {
            title.text = "Touch ID"
        } else if biometricType() == .faceID {
            title.text = "Face ID"
        } else {
            title.text = "App Lock"
        }
        
        let toggle = UISwitch()
        toggle.thumbTintColor = .navigationsWhite
        toggle.onTintColor = .navigationsGreen
        toggle.tintColor = .navigationsWhite
        toggle.isEnabled = false
        
        cell.addSubviews(views: [background, icon, title, toggle, subtext])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 24, height: 24)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        toggle.anchors(right: background.rightAnchor, rightPad: -9, centerY: background.centerYAnchor)
        subtext.anchors(left: title.rightAnchor, leftPad: 6, centerY: background.centerYAnchor)
        
        return cell
    }
    
    @objc func didToggle(_ sender: notifSwitch) {
        didChange = true
        guard let cellType: SettingsCellManager = sender.cellType else { return }
        switch cellType {
        case .notifAssignmentPosted:
            notifDictionary[isAssignmentsPosted] = sender.isOn
            do {
                try Locksmith.updateData(data: notifDictionary, forUserAccount: USER_NOTIF)
            } catch let error {
                print(error)
            }
        case .notifCourseGradeUpdated:
            notifDictionary[isCoursePosted] = sender.isOn
            do {
                try Locksmith.updateData(data: notifDictionary, forUserAccount: USER_NOTIF)
            } catch let error {
                print(error)
            }

        case .notifMiscellaneous:
            notifDictionary[isMisc] = sender.isOn
            do {
                try Locksmith.updateData(data: notifDictionary, forUserAccount: USER_NOTIF)
            } catch let error {
                print(error)
            }
        default: break
        }
    }
}
