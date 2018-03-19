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
        view.backgroundColor = .tableViewGrey
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
        
        let detailsController = ManageIntegrationsDetailsController()
        detailsController.integrationID = integrations.id
        detailsController.syncing = integrations.syncing
        detailsController.manager = self
        
        self.present(detailsController, animated: true, completion: nil)
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
