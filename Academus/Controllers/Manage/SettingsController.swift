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
    var manageController: ManageController?
    var notifSetting = UILabel().setUpLabel(text: "", font: UIFont.subtext!, fontColor: .tableViewLightGrey)
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
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_SETTINGS)
        notifDictionary = dictionary!
        print(dictionary as Any)
        NotificationCenter.default.addObserver(self, selector:#selector(isNotificationsEnabled), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationService().patchNotificationState(didChange: didChange, dictionary: notifDictionary) { (success) in
            if success {
                do {
                    try Locksmith.updateData(data: self.notifDictionary, forUserAccount: USER_SETTINGS)
                    let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_SETTINGS)
                    print(dictionary! as Any)
                } catch {
                    return
                }
            } else {
                self.manageController?.alertMessage(title: "Failed to save notification preferences", message: "Restart Academus or check your internet...")
            }
        }
    }
    
    @objc func isNotificationsEnabled() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let cellAtIndex = cellsFiltered[indexPath.row]
        let cellType = cellAtIndex.getCellType()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        
        switch cellAtIndex {
        case .appLock:
            return biometricsCell(manager: cellAtIndex, cell: cell)
        case .notifAssignmentPosted, .notifCourseGradeUpdated, .notifMiscellaneous: return notificationCell(manager: cellAtIndex, cell: cell)
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

        background.anchors(top: view.topAnchor, topPad: 9, bottom: view.bottomAnchor, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        title.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor)
        subtext.anchors(left: title.rightAnchor, leftPad: 0, centerY: background.centerYAnchor)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 9
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
        cell.clearsContextBeforeDrawing = true
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.standard!, fontColor: .navigationsWhite)
        let icon = UIImageView().setupImageView(color: .navigationsGreen, image: c.getImage())
        let arrow = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "arrowRight"))
        notifSetting.numberOfLines = 2
        notifSetting.lineBreakMode = .byWordWrapping
        background.roundCorners(corners: .bottom)
        
        let subBackground = UIView().setupBackground(bgColor: .navigationsMediumGrey)
        subBackground.roundCorners(corners: .bottom)
        
        let bottomCornerBackground = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        bottomCornerBackground.roundCorners(corners: .top)
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async(execute: {
                    self.notifSetting.text = "Fully customize your notification experience and how you want to see them."
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.notifSetting.text = "Enable notifications to immediately know when your grades change and more."
                })
            }
        }
        
        cell.addSubviews(views: [background, subBackground, bottomCornerBackground, title, icon, notifSetting, arrow])
        
        background.anchors(top: cell.topAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9, height: 55)
        subBackground.anchors(top: background.bottomAnchor, bottom: bottomCornerBackground.topAnchor, bottomPad: -6, left: background.leftAnchor, leftPad: 9, right: background.rightAnchor, rightPad: -9)
        bottomCornerBackground.anchors(bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 5, right: cell.rightAnchor, rightPad: -5, height: 9)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor, width: 24, height: 24)
        arrow.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 32, height: 32)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: background.centerYAnchor)
        notifSetting.anchors(top: subBackground.topAnchor, topPad: 6, left: subBackground.leftAnchor, leftPad: 6, right: subBackground.rightAnchor, rightPad: -6)
        
        cell.selectedBackgroundView = nil
        
        let selectionView = UIView().setupBackground(bgColor: .tableViewDarkGrey)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor =  UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 0.1)
        backgroundView.roundCorners(corners: .bottom)
        
        let subBackground2 = UIView().setupBackground(bgColor: .navigationsMediumGrey)
        subBackground2.roundCorners(corners: .bottom)
        
        let bottomCornerBackground2 = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        bottomCornerBackground2.roundCorners(corners: .top)
        
        selectionView.addSubviews(views: [backgroundView, subBackground2, bottomCornerBackground2])
        
        backgroundView.anchors(top: selectionView.topAnchor, left: selectionView.leftAnchor, leftPad: 9, right: selectionView.rightAnchor, rightPad: -9, height: 55)
        subBackground2.anchors(top: backgroundView.bottomAnchor, bottom: bottomCornerBackground2.topAnchor, bottomPad: -6, left: backgroundView.leftAnchor, leftPad: 9, right: backgroundView.rightAnchor, rightPad: -9)
        bottomCornerBackground2.anchors(bottom: selectionView.bottomAnchor, left: selectionView.leftAnchor, leftPad: 8, right: selectionView.rightAnchor, rightPad: -8, height: 9)
        
        cell.selectedBackgroundView = selectionView
        
        return cell
    }
    
    private func notificationCell(manager: SettingsCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: manager.getTitle(), font: UIFont.standard!, fontColor: .navigationsWhite)
        let icon = UIImageView().setupImageView(color: .navigationsGreen, image: manager.getImage())
        let subtext = UILabel().setUpLabel(text: manager.getSubtext(), font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        
        let toggle = settingSwitch()
        toggle.thumbTintColor = .navigationsWhite
        toggle.onTintColor = .navigationsGreen
        toggle.tintColor = .navigationsWhite
        toggle.cellType = manager
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_SETTINGS)
        switch manager {
        case .notifAssignmentPosted: toggle.isOn = dictionary?[isAssignmentsPosted] as! Bool
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
            
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 24, height: 24)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        toggle.anchors(right: background.rightAnchor, rightPad: -9, centerY: background.centerYAnchor)
        subtext.anchors(top: title.bottomAnchor, left: icon.rightAnchor, leftPad: 12)
        
        return cell
    }
    
    private func biometricsCell(manager: SettingsCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: "", font: UIFont.standard!, fontColor: .navigationsWhite)
        let subtext = UILabel().setUpLabel(text: manager.getSubtext(), font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        
        let icon = UIImageView()
        icon.image = manager.getImage()
        icon.tintColor = .navigationsGreen
        
        if biometricType() == .touchID {
            title.text = "Use Touch ID to unlock"
        } else if biometricType() == .faceID {
            title.text = "Use Face ID to unlock"
        } else {
            title.text = "App Lock"
        }
        
        let toggle = settingSwitch()
        toggle.thumbTintColor = .navigationsWhite
        toggle.onTintColor = .navigationsGreen
        toggle.tintColor = .navigationsWhite
        toggle.cellType = manager
        toggle.addTarget(self, action: #selector(self.didToggle), for: .valueChanged)
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_SETTINGS)
        switch manager {
        case .appLock: toggle.isOn = dictionary?[isAppLock] as! Bool
        default: break
        }
        
        cell.addSubviews(views: [background, icon, title, toggle, subtext])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 9, right: cell.rightAnchor, rightPad: -9)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 24, height: 24)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        toggle.anchors(right: background.rightAnchor, rightPad: -9, centerY: background.centerYAnchor)
        subtext.anchors(left: title.rightAnchor, leftPad: 6, centerY: background.centerYAnchor)
        
        return cell
    }
    
    @objc func didToggle(_ sender: settingSwitch) {
        didChange = true
        guard let cellType: SettingsCellManager = sender.cellType else { return }
        switch cellType {
        case .notifAssignmentPosted: notifDictionary[isAssignmentsPosted] = sender.isOn
        case .notifCourseGradeUpdated: notifDictionary[isCoursePosted] = sender.isOn
        case .notifMiscellaneous: notifDictionary[isMisc] = sender.isOn
        case .appLock: notifDictionary[isAppLock] = sender.isOn;
        try! Locksmith.updateData(data: self.notifDictionary, forUserAccount: USER_SETTINGS)
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: USER_SETTINGS)
        print(dictionary! as Any)
        default: break
        }
    }
}
