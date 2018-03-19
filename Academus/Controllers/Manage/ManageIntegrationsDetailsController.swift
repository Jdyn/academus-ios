//
//  ManageIntegrationsDetailsController.swift
//  Academus
//
//  Created by Jaden Moore on 3/19/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class ManageIntegrationsDetailsController: UIViewController {
    
    let integrationService = IntegrationService()
    var manager: ManageIntegrationsController?
    var integrationID: Int?
    var syncing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tableViewGrey
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.integrationService.syncIntegration(id: self.integrationID!) { (success) in
            if success {
                self.dismiss(animated: true, completion: {
                })
                self.manager?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }

