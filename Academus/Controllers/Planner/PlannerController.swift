//
//  PlannerController.swift
//  Academus
//
//  Created by Jaden Moore on 3/5/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import CoreData

class PlannerController: UITableViewController {
    
    var cards = [PlannerCards]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Planner"
        view.backgroundColor = .tableViewDarkGrey
        tableView.separatorStyle = .none
        
        setupAddButtonInNavBar(selector: #selector(addPlannerCard))
        
        self.extendedLayoutIncludesOpaqueBars = true
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .navigationsGreen
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
    
    func errorLabel(show: Bool) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height)).setUpLabel(text: "Oops... :( \nCreate some cards or comeback later", font: UIFont.UIStandard!, fontColor: .navigationsLightGrey )
        label.textAlignment = .center
        label.numberOfLines = 0
        if show {
            self.tableView.backgroundView = label
        } else {
            self.tableView.backgroundView = nil
        }
    }
    
    @objc func addPlannerCard() {
        let createController = MainNavigationController(rootViewController: PlannerCreateCardController())
        navigationController?.present(createController, animated: true, completion: {
            // COMPLETION CODE HERE
        })
    }
    
    @objc func refreshTable() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (time) in
            self.refreshControl?.endRefreshing()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250), execute: {
                self.tableView.reloadData()
            })
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if cards.count == 0 {
            errorLabel(show: true)
        } else {
            errorLabel(show: false)
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 150 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cards.count }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 9 }
}
//