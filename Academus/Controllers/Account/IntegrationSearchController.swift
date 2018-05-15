//
//  IntegrationSearchController.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 5/11/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class IntegrationSearchController: UITableViewController, IntegrationSearchDelegate {
    
    var integration: IntegrationChoice?
    var integrationService: IntegrationService?
    var coursesController: CoursesController?
    var titleDisplayMode: UINavigationItem.LargeTitleDisplayMode?
    
    var results = [IntegrationResult]()
    let integrationCellID = "SearchIntegrationCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.isHidden = false
        titleDisplayMode = navigationItem.largeTitleDisplayMode
        navigationItem.title = "Find Your District"
        navigationItem.hidesBackButton = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "ZIP Code"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        integrationService?.integrationSearchDelegate = self
        tableView.register(IntegrationSearchCell.self, forCellReuseIdentifier: integrationCellID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.searchController?.searchBar.resignFirstResponder()
        navigationItem.searchController?.resignFirstResponder()
    }
    
    func didGetResults(results: [IntegrationResult]) {
        self.results = results
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
        integrationController.apiBase = results[indexPath.row].api_base
        integrationController.coursesController = coursesController
        integrationController.titleLabel.text = integration?.name

        navigationController?.pushViewController(integrationController, animated: true)
    }
}

extension IntegrationSearchController: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.searchController?.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.searchController?.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text.count > 4 {
            if results.isEmpty {
                let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                ai.color = .navigationsGreen
                ai.startAnimating()
                self.tableView.backgroundView = ai
            }
            
            integrationService?.searchIntegrations(for: text, completion: { (success, error) in
                if success {
                    self.tableView.backgroundView = nil
                    self.navigationItem.hidesSearchBarWhenScrolling = true
                } else {
                    let label = UILabel().setUpLabel(text: error ?? "Please check your Internet connection.", font: UIFont.standard!, fontColor: .white)
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
}
