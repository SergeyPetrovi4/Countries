//
//  CountriesViewController.swift
//  Countries
//
//  Created by Sergey Krasiuk on 18/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import UIKit

class CountriesTableViewController: UITableViewController, CountriesViewProtocol  {
    
    private var presenter: CountriesPresenterProtocol!
    private var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Countries"
        self.setupTableView()
        
        self.presenter = CountriesPresenter(for: self)
    }
    
    // MARK: - UI, Private
    
    private func setupTableView() {
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44.0
    }
    
    // MARK: - Actions
    
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
        cell.configure(with: self.countries[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetails(ofCountry: self.countries[indexPath.row])
    }    
}
