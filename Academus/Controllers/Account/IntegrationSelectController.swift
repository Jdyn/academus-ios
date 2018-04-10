//
//  SelectIntegrationController.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class IntegrationSelectController: UITableViewController, IntegrationChoiceDelegate {
    
    private let integrationService = IntegrationService()
    
    var integrations = [IntegrationChoice]()
    let integrationCellID = "GetIntegrationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.separatorStyle = .none

        integrationService.integrationChoiceDelegate = self
        tableView.register(IntegrationSelectCell.self, forCellReuseIdentifier: integrationCellID)
        integrationService.getIntegrations { (success) in
            if (success) {
                self.tableView.reloadData()
            }
        }
    }
    
    func didGetIntegration(integrations: [IntegrationChoice]) {
        for integration in integrations {
            self.integrations.append(integration)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return integrations.count }
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: integrationCellID, for: indexPath) as? IntegrationSelectCell {
                
            let integration = self.integrations[indexPath.row]
            cell.integration = integration
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 70 }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let integrationController = IntegrationLogInController()
        let integrationService = IntegrationService()
        integrationService.integration = self.integrations[indexPath.row]
        integrationController.integration = self.integrations[indexPath.row]
        integrationController.integrationService = integrationService
        integrationController.titleLabel.text! = self.integrations[indexPath.row].name!
        
        navigationController?.pushViewController(integrationController, animated: true)
    }
}
