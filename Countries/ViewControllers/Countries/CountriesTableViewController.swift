//
//  CountriesViewController.swift
//  Countries
//
//  Created by Sergey Krasiuk on 18/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import UIKit

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
        self.presenter = CountriesPresenter(for: self, type: self.type)
    }
    
    // MARK: - UI, Private
    
    private func setupTableView() {
        
        self.title = self.type == .all ? "Countries" : "Favorites"
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
        if self.type == .all {
            
            let favoritesBarButtonItem = UIBarButtonItem(title: "Favorites",
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(showFavoritesList(_:)))
            self.navigationItem.rightBarButtonItem = favoritesBarButtonItem
        }
    }
    
    // MARK: - Actions
    
    @objc func showFavoritesList(_ sender: UIBarButtonItem) {
        
        let favorites = self.countries.filter({ $0.hasFavorited })
        
        if !favorites.isEmpty {
            self.show(favorites: favorites) { (id) in
                
                // Updating country state in main list of countries
                DispatchQueue.main.async {

                    guard let country = self.countries.filter({ $0.alpha3Code == id }).first else {
                        print("Can`t update country state in main list of countries")
                        return
                    }
                    
                    self.update(country: country)
                }
            }
            
            return
        }
        
        print("Nothing to show. Please select favorites, and try again!")
    }
    
    // MARK: - Private
    
    // MARK: - CountriesViewProtocol
    
    func set(countries: [Country]) {
        
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
    
    func update(country: Country) {
        guard let index = self.countries.enumerated()
                                        .filter({ $0.element.alpha3Code == country.alpha3Code })
                                        .map({ $0.offset }).first else {
                                            
            print("Can`t find and update object")
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
