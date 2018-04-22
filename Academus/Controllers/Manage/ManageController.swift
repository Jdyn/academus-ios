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
        self.extendedLayoutIncludesOpaqueBars = true

        tableView.tableHeaderView = profileView()
        
        cells = [.manageIntegrations, .inviteFriends, .settings, .help, .about]
        cells.forEach { (type) in
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: type.getCellType())
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        
        let cellAtIndex = cellsFiltered[indexPath.row]
        let cellType = cellAtIndex.getCellType()
        let cell = tableView.dequeueReusableCell(withIdentifier: cellType, for: indexPath)
        
        if cellType == "SmallCell" {
            return smallCell(c: cellAtIndex, cell: cell)
        } else if cellType == "MediumCell" {
            return mediumCell(c: cellAtIndex, cell: cell)
        }
    
        return UITableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 18 }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return setupSection(type: .header) }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 18  }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return setupSection(type: .footer) }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return(section == 0 ? 2 : 3) }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }
        return cellsFiltered[indexPath.row].getHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }

        switch cellsFiltered[indexPath.row] {
        case .manageIntegrations: navigationController?.pushViewController(ManageIntegrationsController(style: .grouped), animated: true)
        case .inviteFriends: navigationController?.pushViewController(ManageInvitesController(style: .grouped), animated: true)
        case .settings: navigationController?.pushViewController(SettingsController(style: .grouped), animated: true)
        case .help: navigationController?.pushViewController(Freshchat.sharedInstance().getConversationsControllerForEmbed(), animated: true)
        case .about: navigationController?.pushViewController(ManageAboutController(style: .grouped), animated: true)
        default: break
        }
    }
    
    @objc func handleSignout() {
        let alert = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            if Locksmith.loadDataForUserAccount(userAccount: USER_AUTH) != nil {
                do {
                    try Locksmith.deleteDataForUserAccount(userAccount: USER_AUTH)
                    try Locksmith.deleteDataForUserAccount(userAccount: USER_INFO)
                } catch let error {
                    debugPrint("could not delete locksmith data:", error)
                }
                
                let welcomeNavigationController = MainNavigationController(rootViewController: WelcomeController())
                self.present(welcomeNavigationController, animated: true, completion: {
                    self.tabBarController?.selectedIndex = 0
                })
                
            } else {
                
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
        cell.selectedBackgroundView = selectedBackgroundView()
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.standard!, fontColor: .navigationsWhite)
        let icon = UIImageView()
        icon.image = c.getImage()
        icon.tintColor = .navigationsGreen
        
        cell.addSubviews(views: [background, icon, title])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 24, height: 24)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        
        return cell
    }
    
    private func mediumCell(c: ManageCellManager, cell: UITableViewCell) -> UITableViewCell {
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectedBackgroundView = selectedBackgroundView()
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let title = UILabel().setUpLabel(text: c.getTitle(), font: UIFont.standard!, fontColor: .navigationsWhite)
        
        let icon = UIImageView()
        icon.image = c.getImage()
        icon.tintColor = .navigationsGreen
        
        cell.addSubviews(views: [background, icon, title])
        
        background.anchors(top: cell.topAnchor, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        icon.anchors(left: background.leftAnchor, leftPad: 9, centerY: cell.centerYAnchor, width: 24, height: 24)
        title.anchors(left: icon.rightAnchor, leftPad: 12, centerY: cell.centerYAnchor)
        
        return cell
    }
    
    private func profileView() -> UIView {
        let infoDictionary: Dictionary? = Locksmith.loadDataForUserAccount(userAccount: USER_INFO)
        let authDictionary: Dictionary? = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 95))
        
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let name = UILabel().setUpLabel(text: "\(infoDictionary?["firstName"] ?? "Unkown") \(infoDictionary?["lastName"] ?? "Name")", font: UIFont(name: "AvenirNext-medium", size: 20)!, fontColor: .navigationsWhite)
        let email = UILabel().setUpLabel(text: "\(infoDictionary?["email"] ?? "Unknown Email")", font: UIFont.subtext!, fontColor: .navigationsLightGrey)
    
        background.layer.cornerRadius = 9
        background.layer.masksToBounds = true
        background.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        
        let profileImage = UIImageView()
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "\(BASE_URL)/api/picture?token=\(authDictionary?[AUTH_TOKEN] ?? "")")
            guard let data = try? Data(contentsOf: url!) else {return}

            DispatchQueue.main.async {
                profileImage.image = UIImage(data: data)
                profileImage.layer.masksToBounds = true
                profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
            }
        }
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(15.0, 0.0, 15.0, 0.0)
        button.addTarget(self, action: #selector(handleSignout), for: .touchUpInside)
        button.tintColor = .navigationsRed
        
        let stack = UIStackView(arrangedSubviews: [name, email])
        stack.axis = .vertical
        stack.distribution = .equalCentering
        view.addSubviews(views: [background, stack, button, profileImage])
        
        background.anchors(top: view.topAnchor, bottom: view.bottomAnchor, bottomPad: -9, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        stack.anchors(left: profileImage.rightAnchor, leftPad: 9, centerY: profileImage.centerYAnchor)
        profileImage.anchors(left: background.leftAnchor, leftPad: 6, centerY: background.centerYAnchor, width: 64, height: 64)
        button.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 64, height: 64)
        
        return view
    }
    
    private func selectedBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .tableViewDarkGrey
        let selectedView = UIView()
        selectedView.backgroundColor =  UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 0.1)
        view.addSubview(selectedView)
        selectedView.anchors(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6)
        return view
    }
}
