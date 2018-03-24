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
    var cellType = [CellTypes]()
    var cells = [ManageCellManager]()
    
    let profile: UIView = {
        let dictionary: Dictionary? = Locksmith.loadDataForUserAccount(userAccount: USER_AUTH)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 75))
        view.backgroundColor = .tableViewDarkGrey
        
        let background = UIView()
        background.backgroundColor = .tableViewMediumGrey
//        background.layer.cornerRadius = 5
//        background.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        let size = CGSize(width: 0, height: 0)
//        background.setUpShadow(color: .black, offset: size, radius: 2, opacity: 0.4)
        
        let name = UILabel()
        name.font = UIFont(name: "AvenirNext-demibold", size: 14)
        name.text = "\(dictionary?["firstName"] ?? "Unkown") \(dictionary?["lastName"] ?? "Name")"
        name.textColor = .navigationsWhite
        
        let email = UILabel()
        email.font = UIFont(name: "Avenir-light", size: 12)
        email.text = "\(dictionary?["email"] ?? "Unknown Email")"
        email.textColor = .navigationsLightGrey
        
        let image = UIImageView()
        image.tintColor = .navigationsLightGrey
        image.image = #imageLiteral(resourceName: "profile")
        
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "exit"), for: .normal)
        button.addTarget(self, action: #selector(handleSignout), for: .touchUpInside)
        button.tintColor = .navigationsRed
        
        view.addSubview(background)
        view.addSubview(button)
        view.addSubview(name)
        view.addSubview(email)
        view.addSubview(image)
        
        background.anchors(top: view.topAnchor, topPad: 0, bottom: view.bottomAnchor, bottomPad: 0, left: view.leftAnchor, leftPad: 6, right: view.rightAnchor, rightPad: -6, width: 0, height: 0)
        
        image.anchors(left: background.leftAnchor, leftPad: 6, centerY: background.centerYAnchor, width: 48, height: 48)
        name.anchors(bottom: image.centerYAnchor, left: image.rightAnchor, leftPad: 6, width: 0, height: 0)
        email.anchors(top: image.centerYAnchor, left: image.rightAnchor, leftPad: 6, width: 0, height: 0)
        button.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 0, height: 0)

        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Manage"
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = .tableViewDarkGrey
        tableView.tableHeaderView = profile
        
        cellType = [.manageMediumCell, .manageSmallCell]
        cells = [.manageIntegrations, .manageInvites, .settings, .help, .about]
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellClass.cellReuseIdentifier(), for: indexPath) as! MainCell
        cell.set(title: c.getTitle(), image: c.image(), subtext: c.getSubtext())
        cell.type = c.cellType()
        cell.index = indexPath.row
        return cell
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellsFiltered = cells.filter { $0.getSection() == indexPath.section }

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
        if section == 0 {
            return 2
        } else {
            return 3
        }
//            return cells[section].rowCount()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellType[indexPath.section].getHeight()
    }
}
