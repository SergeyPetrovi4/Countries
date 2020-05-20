//
//  CountriesPresenter.swift
//  Countries
//
//  Created by Sergey Krasiuk on 18/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation

class CountriesPresenter: CountriesPresenterProtocol {
    
    weak var view: CountriesViewProtocol?
    
    init(`for` view: CountriesViewProtocol) {
        self.view = view
    }
    
    // MARK: - Private

    // MARK: - CountriesPresenterProtocol
    
    func fetchCountries(service: NetworkServiceRepresentable) {
        
        let params = ["fields" : "name;flag;capital;timezones;nativeName;population;languages;translations;alpha3Code;alpha2Code"]
        WebServiceManager.shared.fetch(service: service, params: params) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.updateFavorites(in: countries)
                    
                case .failure(let error):
                    self.view?.showAlert(title: error.localizedDescription,
                                         message: nil,
                                         style: .alert,
                                         actions: Alerts.NetworkAlerts.self,
                                         completion: { (action) in
                                            
                            switch action {
                            case .OK: return
                            case .Retry:
                                self.fetchCountries(service: service)
                            }
                    })
                }
            }
        }
    }
    
    func updateFavorites(in countries: [Country]) {
        
        let favorites = FavoritesManager.shared.favorites
        var passedCountries = countries // Make var (countries == let)
        
        if favorites.isEmpty {
            print("Favorites: Nothing to update")
            self.view?.set(countries: countries)
            return
        }
        
        // MARK: - Updating states favorites in countries
        favorites.forEach { (favorite) in
            if let index = passedCountries.enumerated().filter({ $0.element.alpha3Code == favorite }).map({ $0.offset }).first {
                passedCountries[index].hasFavorited = !passedCountries[index].hasFavorited
            }
        }
        
        self.view?.set(countries: passedCountries)
    }
}
