//
//  RoutableViewControllerProtocol.swift
//  Meuhedet
//
//  Created by Sergey Krasiuk on 17/04/2018.
//  Copyright © 2018 Sergey Krasiuk. All rights reserved.
//

import UIKit

typealias FavoritesCompletionHandler = ((String) -> Void)

protocol RoutableProtocol {
    
    // MARK: - Pop`s
    
    func pop()
    
    // MARK: - Details
    
    func showDetails(ofCountry country: Country, type: CountriesTableViewController.CountriesType, delegate: DetailsDelegate?)
    
    // MARK: - Favorites
    
    func show(favorites countries: [Country], completion: FavoritesCompletionHandler?)
}

extension RoutableProtocol where Self: UIViewController {
    
    // MARK: - Pop`s implementation
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Details implementation
    
    func showDetails(ofCountry country: Country, type: CountriesTableViewController.CountriesType, delegate: DetailsDelegate?) {
        
        let detailsViewController = DetailsViewController.instantiateFrom(storyboard: .main)
        detailsViewController.country = country
        detailsViewController.type = type // For favorites
        detailsViewController.delegate = delegate
        self.show(detailsViewController, sender: nil)
    }
    
    // MARK: - Favorites implementation
    
    func show(favorites countries: [Country], completion: FavoritesCompletionHandler?) {
        
        let countriesTableViewController = CountriesTableViewController.instantiateFrom(storyboard: .main)
        countriesTableViewController.type = .favorites
        countriesTableViewController.set(countries: countries)
        countriesTableViewController.completion = completion
        self.show(countriesTableViewController, sender: nil)
    }
}

