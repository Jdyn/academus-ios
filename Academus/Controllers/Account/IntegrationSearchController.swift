//
//  IntegrationSearchController.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 5/11/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class IntegrationSearchController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating,  IntegrationSearchDelegate {
    
    var integration: IntegrationChoice?
    var integrationService: IntegrationService?
    var coursesController: CoursesController?
    var titleDisplayMode: UINavigationItem.LargeTitleDisplayMode?
    
    var results = [IntegrationResult]()
    let integrationCellID = "SearchIntegrationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        extendedLayoutIncludesOpaqueBars = true
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0)
        titleDisplayMode = navigationItem.largeTitleDisplayMode
        navigationItem.title = "District Selection"
        navigationItem.hidesBackButton = false
        tableView.separatorStyle = .none
        
        print(integration?.route)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "ZIP Code"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        integrationService?.integrationSearchDelegate = self
        tableView.register(IntegrationSearchCell.self, forCellReuseIdentifier: integrationCellID)
    }
    
    func didGetResults(results: [IntegrationResult]) {
        self.results = results
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        navigationItem.searchController?.dimsBackgroundDuringPresentation = true
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 2 {
            integrationService?.searchIntegrations(for: text, completion: { (success, error) in
                if success {
                    self.tableView.backgroundView = nil
                    self.navigationItem.hidesSearchBarWhenScrolling = true
                } else if let e = error {
                    let label = UILabel().setUpLabel(text: e, font: UIFont.standard!, fontColor: .white)
                    label.numberOfLines = 0
                    label.textAlignment = .center
                    self.tableView.backgroundView = label
                    self.results = [IntegrationResult]()
                    self.navigationItem.hidesSearchBarWhenScrolling = false
                }
                
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return results.count }
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: integrationCellID, for: indexPath) as? IntegrationSearchCell {
            cell.title.text = results[indexPath.row].name
            cell.location.text = results[indexPath.row].address
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 80 }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let integrationController = IntegrationLogInController()
        let integrationService = IntegrationService()
        integrationService.integration = integration
        integrationController.integration = integration
        integrationController.integrationService = integrationService
        integrationController.coursesController = self.coursesController
        integrationController.titleLabel.text! = self.results[indexPath.row].name!

        navigationController?.pushViewController(integrationController, animated: true)
    }

}
