//
//  ManageIntegrationsController.swift
//  Academus
//
//  Created by Jaden Moore on 3/15/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageIntegrationsController: UITableViewController, UserIntegrationsDelegate {

    let integrationService = IntegrationService()
    var integrations = [UserIntegrations]()
    let cellID = "userIntegrationsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Manage Integrations"
        view.backgroundColor = .tableViewDarkGrey
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(ManageIntegrationsCell.self, forCellReuseIdentifier: cellID)
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
        self.integrations.removeAll()
        for integration in integrations {
            self.integrations.append(integration)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ManageIntegrationsCell {
            
            let integration = self.integrations[indexPath.row]
            cell.integration = integration
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let integrations = self.integrations[indexPath.row]
        loadingAlert(title: "Syncing", message: "Syncing Integration")
        integrationService.syncIntegration(id: integrations.id!) { (success) in
            if success {
                self.integrationService.userIntegrationsDelegate = self
                self.integrationService.userIntegrations(completion: { (success) in
                    self.dismiss(animated: true, completion: {
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                })
            } else {
                self.dismiss(animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.alertMessage(title: "Alert", message: "Failed to sync integration")
                })
            }
        }
    }
    
    @objc func reload() {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return integrations.count
    }
}
