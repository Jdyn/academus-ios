//
//  SelectIntegrationController.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class SelectIntegrationController: UITableViewController, IntegrationServiceDelegate {
    
    private let integrationService = IntegrationService()
    
    var integrations = [Integration]()
    let integrationCellID = "GetIntegrationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select integrations"
        navigationItem.hidesBackButton = true
        integrationService.delegate = self
        tableView.register(GetIntegrationCell.self, forCellReuseIdentifier: integrationCellID)
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.tableViewSeperator
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        integrationService.getIntegrations { (success) in
            if (success) {
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetIntegration(integrations: [Integration]) {
        for integration in integrations {
            self.integrations.append(integration)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return integrations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: integrationCellID, for: indexPath) as? GetIntegrationCell {
            
            let integration = self.integrations[indexPath.row]
            cell.integration = integration
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
