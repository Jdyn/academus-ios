//
//  ManageIntegrationsController.swift
//  Academus
//
//  Created by Jaden Moore on 3/15/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageIntegrationsController: UITableViewController, UserIntegrationsDelegate {

    let date = UILabel().setUpLabel(text: "", font: UIFont.subtext!, fontColor: .tableViewLightGrey)
    let integrationService = IntegrationService()
    var integrations = [UserIntegrations]()
    let cellID = "userIntegrationsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Manage Integrations"
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        integrationService.userIntegrationsDelegate = self
        integrationService.userIntegrations { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }

    func didGetUserIntegrations(integrations: [UserIntegrations]) {
        print("integrations protocol called")
        self.integrations.removeAll()
        for integration in integrations {
            self.integrations.append(integration)
        }
    }
    
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
                            self.date.text = "Synced"
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 65 }
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return integrations.count }
}

extension ManageIntegrationsController {
    
    private func integrationCell(cell: UITableViewCell, integration: UserIntegrations) -> UITableViewCell {
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let name = UILabel().setUpLabel(text: integration.name ?? "", font: UIFont.subtext!, fontColor: .navigationsWhite)
        
        let circle = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        circle.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = circle.frame.size.width / 2//view.frame.size.width / 2
        
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
        
        let lastSynced = integration.last_synced
        let formattedDate = timeAgoStringFromDate(date: lastSynced!)
        date.text = "last synced: \(formattedDate ?? "Error")"
        
        let syncIcon = UIImageView().setupImageView(color: .navigationsGreen, image: #imageLiteral(resourceName: "sync"))
        let sync = UILabel().setUpLabel(text: "Sync now", font: UIFont.subtext!, fontColor: .navigationsLightGrey)
        
        cell.backgroundColor = .tableViewDarkGrey
        cell.selectionStyle = .none
        
        let stackView = UIStackView(arrangedSubviews: [ icon, name, date ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        
        cell.addSubviews(views: [background, circle, stackView, icon, name, date, sync, syncIcon])
            
        background.anchors(top: cell.topAnchor, topPad: 6, bottom: cell.bottomAnchor, left: cell.leftAnchor, leftPad: 6, right: cell.rightAnchor, rightPad: -6)
        circle.anchors(left: background.leftAnchor, leftPad: 6, centerY: background.centerYAnchor, width: 10, height: 10)
        stackView.anchors(left: circle.rightAnchor, leftPad: 6, centerY: background.centerYAnchor)
        icon.anchors(left: stackView.leftAnchor, centerY: stackView.centerYAnchor ,width: 28, height: 28)
        name.anchors(top: icon.topAnchor, left: icon.rightAnchor, leftPad: 6)
        date.anchors(bottom: icon.bottomAnchor, left: icon.rightAnchor, leftPad: 6)
        sync.anchors(right: background.rightAnchor, rightPad: -6, centerY: background.centerYAnchor)
        syncIcon.anchors(right: sync.leftAnchor, rightPad: -6, centerY: background.centerYAnchor, width: 16, height: 16)
        return cell
    }
    
    private func headerView() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let background = UIView().setupBackground(bgColor: .tableViewMediumGrey)
        let counter = UILabel().setUpLabel(text: "Current Integrations", font: UIFont.subtext!, fontColor: .navigationsWhite)
        
        header.addSubviews(views: [background, counter])
        
        background.anchors(top: header.topAnchor, bottom: header.bottomAnchor, left: header.leftAnchor, leftPad: 6, right: header.rightAnchor, rightPad: -6)
        counter.anchors(centerX: background.centerXAnchor, centerY: background.centerYAnchor)
        return header
    }
}
