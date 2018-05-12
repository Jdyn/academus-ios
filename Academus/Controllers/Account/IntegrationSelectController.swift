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
    var coursesController: CoursesController?
    var titleDisplayMode: UINavigationItem.LargeTitleDisplayMode?
    
    var integrations = [IntegrationChoice]()
    let integrationCellID = "GetIntegrationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        titleDisplayMode = navigationItem.largeTitleDisplayMode
        navigationItem.title = "Select an Integration"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let displayMode = titleDisplayMode {
            navigationItem.largeTitleDisplayMode = displayMode
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 80 }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if integrations[indexPath.row].route == "studentvue" {
            let integrationSearchController = IntegrationSearchController()
            let integrationService = IntegrationService()
            integrationSearchController.integration = integrations[indexPath.row]
            integrationSearchController.integrationService = integrationService
            integrationSearchController.coursesController = coursesController
            navigationController?.pushViewController(integrationSearchController, animated: true)
        } else {
            let integrationController = IntegrationLogInController()
            let integrationService = IntegrationService()
            integrationService.integration = integrations[indexPath.row]
            integrationController.integration = integrations[indexPath.row]
            integrationController.integrationService = integrationService
            integrationController.coursesController = coursesController
            integrationController.titleLabel.text! = integrations[indexPath.row].name!
            navigationController?.pushViewController(integrationController, animated: true)
        }
    }
}
