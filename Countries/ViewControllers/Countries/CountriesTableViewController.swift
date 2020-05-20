//
//  CountriesViewController.swift
//  Countries
//
//  Created by Sergey Krasiuk on 18/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import UIKit
import RappleProgressHUD

class CountriesTableViewController: UITableViewController, CountriesViewProtocol  {
    
    enum CountriesType {
        case all
        case favorites
    }
    
    var type = CountriesType.all
    var completion: FavoritesCompletionHandler? // For favorites
    
    private var presenter: CountriesPresenterProtocol!
    private var countries = [Country]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupUI()
        self.presenter = CountriesPresenter(for: self)
        
        if self.type == .all {
            RappleActivityIndicatorView.startAnimating()
            self.presenter.fetchCountries(service: CountriesService.all)
        }
    }
    
    // MARK: - UI, Private
    
    private func setupTableView() {
        
        self.title = self.type == .all ? "Countries" : "Favorites"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }
    
    private func setupUI() {
        
        if self.type == .favorites {
            return
        }
            
        let favoritesBarButtonItem = UIBarButtonItem(title: "Favorites",
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(showFavoritesList(_:)))
        self.navigationItem.rightBarButtonItem = favoritesBarButtonItem
        
        // Search controller
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        self.navigationItem.searchController = searchController
    }
    
    // MARK: - Actions
    
    @objc func showFavoritesList(_ sender: UIBarButtonItem) {
        
        let favorites = self.countries.filter({ $0.hasFavorited })
        
        if !favorites.isEmpty {
            self.show(favorites: favorites) { (id) in
                
                // Updating country state in main list of countries
                DispatchQueue.main.async {
                    guard let country = self.countries.filter({ $0.alpha3Code == id }).first else {
                        self.showAlert(title: "Can`t update country state in main list of countries",
                                       message: nil,
                                       style: .alert,
                                       actions: Alerts.DataAlert.self,
                                       completion: nil)
                        return
                    }
                    
                    self.update(country: country)
                }
            }
            
            return
        }
        
        self.showAlert(title: "Nothing to show. Please select favorites, and try again!",
                        message: nil,
                        style: .alert,
                        actions: Alerts.DataAlert.self,
                        completion: nil)
    }
    
    // MARK: - Private
    
    // MARK: - CountriesViewProtocol
    
    func set(countries: [Country]) {
        
        RappleActivityIndicatorView.stopAnimation()
        self.countries = countries
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CountryViewCell.self), for: indexPath) as! CountryViewCell
        cell.configure(with: self.countries[indexPath.row], atIndexPath: indexPath) { [weak self] (objectIndex) in
            
            DispatchQueue.main.async {

                let id = self?.countries[objectIndex.row].alpha3Code
                
                if !FavoritesManager.shared.isExist(favorite: id!) {
                    FavoritesManager.shared.append(favorite: id!)
                } else {
                    FavoritesManager.shared.remove(favorite: id!)
                }
                
                if self?.type == .favorites { // For favorites screen
                    self?.countries.remove(at: objectIndex.row)
                    self?.tableView.reloadData()
                    
                     // Updating main list of countries from Favorites
                    self?.completion?(id!)
                    return
                }
                
                self?.countries[objectIndex.row].hasFavorited = FavoritesManager.shared.isExist(favorite: id!)
                self?.tableView.beginUpdates()
                self?.tableView.reloadRows(at: [objectIndex], with: .fade)
                self?.tableView.endUpdates()
            }
            
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetails(ofCountry: self.countries[indexPath.row], type: self.type, delegate: self)
    }    
}

extension CountriesTableViewController: DetailsDelegate {
    
    // MARK: - DetailsDelegate
    
    func update(country: Country) {
        guard let index = self.countries.enumerated()
                                        .filter({ $0.element.alpha3Code == country.alpha3Code })
                                        .map({ $0.offset }).first else {
                                            
            self.showAlert(title: "Can`t find and update object",
                            message: nil,
                            style: .alert,
                            actions: Alerts.DataAlert.self,
                            completion: nil)
            return
        }
        
        let id = self.countries[index].alpha3Code
        self.countries[index].hasFavorited = FavoritesManager.shared.isExist(favorite: id)
        
        if self.type == .favorites { // For favorites screen
            self.countries.remove(at: index)
            self.completion?(id)
        }
        
        self.tableView.reloadData()
    }
}

extension CountriesTableViewController: UISearchBarDelegate {
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = searchBar.text else {
            return
        }
        
        self.presenter.fetchCountries(service: CountriesService.search(searchText))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.presenter.fetchCountries(service: CountriesService.all)
    }
}
