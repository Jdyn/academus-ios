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
    
    var cells = [ManageCellManager]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Manage"
        tableView.separatorStyle = .none
        tableView.tableHeaderView = profileView()
        
        cells = [.manageIntegrations, .manageInvites, .settings, .help, .about]
        cells.forEach { (type) in
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: type.getCellType())
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let cellAtIndex = cellsFiltered[indexPath.row]
        let cellClass = cellAtIndex.getCellType()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellClass, for: indexPath)
        
        if cellClass == "SmallCell" {
            return smallCell(c: cellAtIndex, cell: cell)
        } else if cellClass == "MediumCell" {
            return mediumCell(c: cellAtIndex, cell: cell)
        }
    
        return UITableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 9 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return(section == 0 ? 2 : 3) }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        return cellsFiltered[indexPath.row].getHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        if cellsFiltered[indexPath.row] == .manageIntegrations {
            navigationController?.pushViewController(ManageIntegrationsController(), animated: true)
        } else if cellsFiltered[indexPath.row] == .manageInvites {
            navigationController?.pushViewController(ManageInvitesController(), animated: true)
        } else if cellsFiltered[indexPath.row] == .settings {
//            navigationController?.pushViewController(SettingsController(), animated: true)
        } else if cellsFiltered[indexPath.row] == .help {
            navigationController?.pushViewController(ManageHelpController(), animated: true)
        } else if cellsFiltered[indexPath.row] == .about {
//            navigationController?.pushViewController(ManageAboutController(), animated: true)
        }
    }
    
    @objc func handleSignout() {
        let alert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) != nil {
                do {
                    try Locksmith.deleteDataForUserAccount(userAccount: USER_AUTH)
                } catch let error {
                    debugPrint("could not delete locksmith data:", error)
                }
                let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
                self.present(welcomeNavigationController, animated: true, completion: {
                    self.tabBarController?.selectedIndex = 0
                })
            }
        }
        
        let actionNo = UIAlertAction(title: "No", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionNo)
        alert.addAction(actionYes)
        present(alert, animated: true, completion: nil)
    }
}

extension ManageController {
    
    private func smallCell(c: ManageCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.UIStandard!, fontColor: .navigationsWhite)
        
        let icon = UIImageView()
        icon.image = c.getImage()
        icon.tintColor = .navigationsGreen
        
        cell.addSubviews(views: [background, icon, title])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        
        return cell
    }
    
    private func mediumCell(c: ManageCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.UIStandard!, fontColor: .navigationsWhite)
        
        let icon = UIImageView()
        icon.image = c.getImage()
        icon.tintColor = .navigationsGreen
        
        cell.addSubviews(views: [background, icon, title])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 20, height: 20)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        
        return cell
    }
    
    private func profileView() -> UIView {
        let dictionary: Dictionary? = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 75))
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let name = UILabel().setUpLabel(text: "\(dictionary?["firstName"] ?? "Unkown") \(dictionary?["lastName"] ?? "Name")", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
        let email = UILabel().setUpLabel(text: "\(dictionary?["email"] ?? "Unknown Email")", font: UIFont.UISubtext!, fontColor: .navigationsLightGrey)
        
        let image = UIImageView()
        image.tintColor = .navigationsLightGrey
        image.image = #imageLiteral(resourceName: "profile")
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        button.addTarget(self, action: #selector(handleSignout), for: .touchUpInside)
        button.tintColor = .navigationsRed
        
        view.addSubviews(views: [background, button, name, email, image])
        
        background.anchors(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        image.anchors(left: background.leftAnchor, leftPad: 6, centerY: background.centerYAnchor, width: 48, height: 48)
        name.anchors(bottom: image.centerYAnchor, left: image.rightAnchor, leftPad: 6)
        email.anchors(top: image.centerYAnchor, left: image.rightAnchor, leftPad: 6)
        button.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor)
        
        return view
    }
}
