//
//  CountriesContract.swift
//  Countries
//
//  Created by Sergey Krasiuk on 18/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation

protocol CountriesViewProtocol: class, RoutableProtocol {
    
    func set(countries: [Country])
}

protocol CountriesPresenterProtocol {
    
    func fetchCountries(service: NetworkServiceRepresentable)
    func updateFavorites(in countries: [Country])
}

enum CountriesService: NetworkServiceRepresentable {
    case all
    case search(String)
    
    var rawValue: String {
        get {
            switch self {
            case .all:
                return "all"
            case .search(let text):
                return "name/\(text)"
            }
        }
    }
}
