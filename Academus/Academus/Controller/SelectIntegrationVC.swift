//
//  SelectIntegrationVC.swift
//  Academus
//
//  Created by Jaden Moore on 2/13/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class SelectIntegrationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        myTableView.delegate = self
        myTableView.dataSource = self
        IntegrationService.instance.getIntegrations { (succes) in
            self.myTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IntegrationService.instance.integrations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "integrationCell", for: indexPath) as? IntegrationCell {
            cell.configureCell(integration: IntegrationService.instance.integrations[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}

