//
//  ManageIntegrationsController.swift
//  Academus
//
//  Created by Jaden Moore on 3/15/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import Locksmith

class ManageIntegrationsController: UITableViewController, UserIntegrationsDelegate {

    let date = UILabel().setUpLabel(text: "", font: UIFont.subheader!, fontColor: .tableViewLightGrey)
    let integrationService = IntegrationService()
    var integrations = [UserIntegrations]()

    let cellID = "userIntegrationsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Manage Integrations"
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView()
        setupAddButtonInNavBar(selector: #selector(handleAdd))
        self.extendedLayoutIncludesOpaqueBars = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        integrationService.userIntegrationsDelegate = self
        integrationService.userIntegrations { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
//        statusService.statusDelegate = self
//        statusService.getStatus { (success) in
//            if success {
//                print(self.components)
//            }
//        }
    }

    func didGetUserIntegrations(integrations: [UserIntegrations]) {
        print("integrations protocol called")
        self.integrations.removeAll()
        for integration in integrations {
            self.integrations.append(integration)
        }
    }
    
//    func didGetStatus(components: [ComponentModel]) {
//        components.forEach { (component) in
//            self.components.append(component)
//        }
//    }
    
    @objc func handleAdd() {
        let controller = IntegrationSelectController()
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        controller.navigationItem.title = "Add an Integration"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleCancel() { self.navigationController?.popViewController(animated: true) }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        return integrationCell(cell: cell, integration: integrations[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let integrations = self.integrations[indexPath.row]
        loadingAlert(title: "Syncing", message: "Syncing Integration")
        integrationService.syncIntegration(id: integrations.id!) { (success) in
            if success {
                self.integrationService.userIntegrationsDelegate = self
                self.integrationService.userIntegrations(completion: { (success) in
                    if success {
                        self.dismiss(animated: true, completion: {
                            self.date.text = "Queued for Sync"
                        })
                    }
                })
            } else {
                self.dismiss(animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.alertMessage(title: "Alert", message: "Failed to sync integration")
                })
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 85 }
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return integrations.count }
}

extension ManageIntegrationsController {
    
    private func integrationCell(cell: UITableViewCell, integration: UserIntegrations) -> UITableViewCell {
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        background.roundCorners(corners: .all)
        
        let name = UILabel().setUpLabel(text: integration.name ?? "Error", font: UIFont.standard!, fontColor: .navigationsWhite)
        
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        circle.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = circle.frame.size.width / 2
        
        if integration.last_sync_did_error == true {
            circle.backgroundColor = .navigationsRed
        } else {
            circle.backgroundColor = .navigationsGreen
        }
        
        let icon = UIImageView()
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: integration.icon_url ?? "")
            guard let data = try? Data(contentsOf: url!) else {return}
            
            DispatchQueue.main.async {
                icon.image = UIImage(data: data)
            }
        }
        
        if let lastSynced = integration.last_synced {
            let formattedDate = timeAgoStringFromDate(date: lastSynced)
            date.text = "last synced: \(formattedDate ?? "Error")"
        }

        let syncIcon = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "sync"))
        
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        cell.addSubviews(views: [background, circle, icon, name, date, syncIcon])
            
        background.anchors(top: cell.topAnchor, topPad: 6, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        circle.anchors(left: background.leftAnchor, leftPad: 9, centerY: background.centerYAnchor, width: 12, height: 12)
        icon.anchors(left: circle.rightAnchor, leftPad: 9, centerY: background.centerYAnchor , width: 32, height: 32)
        name.anchors(bottom: icon.centerYAnchor ,left: icon.rightAnchor, leftPad: 9, right: syncIcon.leftAnchor, rightPad: -6)
        date.anchors(top: icon.centerYAnchor, topPad: 0, left: icon.rightAnchor, leftPad: 9)
        syncIcon.anchors(right: background.rightAnchor, rightPad: -16, centerY: background.centerYAnchor, width: 24, height: 24)
        return cell
    }
    
    private func headerView() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 45))
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let counter = UILabel().setUpLabel(text: "Current Integrations", font: UIFont.standard!, fontColor: .navigationsWhite)
        
        background.roundCorners(corners: .bottom)
        
        header.addSubviews(views: [background, counter])
        
        background.anchors(top: header.topAnchor, bottom: header.bottomAnchor, left: header.leftAnchor, leftPad: 6, right: header.rightAnchor, rightPad: -6)
        counter.anchors(centerX: background.centerXAnchor, centerY: background.centerYAnchor)
        return header
    }
}
