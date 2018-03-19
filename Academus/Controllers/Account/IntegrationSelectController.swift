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
        integrationService.integrationChoiceDelegate = self
        tableView.register(GetIntegrationCell.self, forCellReuseIdentifier: integrationCellID)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
            return integrations.count
//        } else {
//            return 0
//        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: integrationCellID, for: indexPath) as? GetIntegrationCell {
                
            let integration = self.integrations[indexPath.row]
            cell.integration = integration
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let integrationController = IntegrationLogInController()
        let integrationService = IntegrationService()
        integrationService.integration = self.integrations[indexPath.row]
        integrationController.integration = self.integrations[indexPath.row]
        integrationController.integrationService = integrationService
        integrationController.titleLabel.text = self.integrations[indexPath.row].name
        
        navigationController?.pushViewController(integrationController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            view.backgroundColor = .tableViewGrey
            let headerLabel = UILabel()
            headerLabel.setUpLabel(text: "Core Integrations", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
            headerLabel.textAlignment = .center
            view.addSubview(headerLabel)
            headerLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 0, height: 0)
            return view
//        } else {
//            let view = UIView()
//            view.backgroundColor = .tableViewGrey
//            let headerLabel = UILabel()
//            headerLabel.setUpLabel(text: "More coming soon", font: UIFont.UIStandard!, fontColor: .navigationsWhite)
//            headerLabel.textAlignment = .center
//            view.addSubview(headerLabel)
//            headerLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor, width: 0, height: 0)
//            return view
        }
            return UITableViewCell()
    }
}
