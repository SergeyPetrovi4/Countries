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
    
    func updateFavorites(in countries: [Country])
}
