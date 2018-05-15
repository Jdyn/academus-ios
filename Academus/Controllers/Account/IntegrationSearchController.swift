//
//  IntegrationSearchController.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 5/11/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit
import CoreLocation

enum SearchMode {
    case zip
    case filter
}

class IntegrationSearchController: UITableViewController, IntegrationSearchDelegate {
    
    var integration: IntegrationChoice?
    var integrationService: IntegrationService?
    var coursesController: CoursesController?
    var titleDisplayMode: UINavigationItem.LargeTitleDisplayMode?
    
    var filtered = [IntegrationResult]()
    var results = [IntegrationResult]()
    var searchMode = SearchMode.zip {
        didSet {
            if searchMode == .zip {
                navigationItem.searchController?.searchBar.setImage(#imageLiteral(resourceName: "location"), for: .search, state: .normal)
                navigationItem.searchController?.searchBar.placeholder = "ZIP Code"
            } else {
                navigationItem.searchController?.searchBar.setImage(#imageLiteral(resourceName: "search"), for: .search, state: .normal)
                navigationItem.searchController?.searchBar.placeholder = "Filter Districts"
            }
        }
    }
    var locationManager = CLLocationManager()
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
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white
        searchController.searchBar.placeholder = "ZIP Code"
        searchController.searchBar.setImage(#imageLiteral(resourceName: "location"), for: .search, state: .normal)
        searchController.searchBar.enablesReturnKeyAutomatically = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        integrationService?.integrationSearchDelegate = self
        tableView.register(IntegrationSearchCell.self, forCellReuseIdentifier: integrationCellID)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.searchController?.searchBar.resignFirstResponder()
        navigationItem.searchController?.resignFirstResponder()
    }
    
    func didGetResults(results: [IntegrationResult]) {
        self.filtered = results
        self.results = results
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return filtered.count }
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: integrationCellID, for: indexPath) as? IntegrationSearchCell {
            cell.title.text = filtered[indexPath.row].name
            cell.location.text = filtered[indexPath.row].address
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
        integrationController.apiBase = filtered[indexPath.row].api_base
        integrationController.coursesController = coursesController
        integrationController.titleLabel.text = integration?.name

        navigationController?.pushViewController(integrationController, animated: true)
    }
}

extension IntegrationSearchController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil, let placemark = placemarks?.first, let zip = placemark.postalCode {
                manager.stopUpdatingLocation()
                self.navigationItem.searchController?.searchBar.text = zip
            }
        })
    }
}

extension IntegrationSearchController: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.searchController?.resignFirstResponder()
        searchBar.text = (searchMode == .filter) ? searchBar.text : nil
        searchMode = .filter
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        navigationItem.searchController?.resignFirstResponder()
        searchMode = .zip
        filtered = results
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchMode == .filter {
            guard let text = searchController.searchBar.text, !text.isEmpty else {
                filtered = results
                tableView.reloadData()
                return
            }
            
            filtered = results.filter { $0.name?.lowercased().contains(text.lowercased()) == true }
            tableView.reloadData()
        } else {
            if let text = searchController.searchBar.text, text.count > 4 {
                if filtered.isEmpty {
                    let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                    ai.color = .navigationsGreen
                    ai.startAnimating()
                    self.tableView.backgroundView = ai
                }
                
                integrationService?.searchIntegrations(for: text, completion: { (success, error) in
                    if success {
                        self.tableView.backgroundView = nil
                        self.navigationItem.hidesSearchBarWhenScrolling = true
                        
                        if !searchController.searchBar.isFirstResponder {
                            self.navigationItem.hidesSearchBarWhenScrolling = false
                            searchController.searchBar.text = (self.searchMode == .filter) ? searchController.searchBar.text : nil
                            self.searchMode = .filter
                        }
                        
                    } else {
                        let label = UILabel().setUpLabel(text: error ?? "Please check your Internet connection.", font: UIFont.standard!, fontColor: .white)
                        label.numberOfLines = 0
                        label.textAlignment = .center
                        self.tableView.backgroundView = label
                        self.filtered = [IntegrationResult]()
                        self.results = [IntegrationResult]()
                        self.navigationItem.hidesSearchBarWhenScrolling = false
                    }
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
}
