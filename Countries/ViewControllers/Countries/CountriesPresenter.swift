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
        
        self.fetchCountries()
    }
    
    // MARK: - Private
    
    private func fetchCountries() {
        
        let params = ["fields" : "name;flag;capital;timezones;nativeName;population;languages;translations"]
        WebServiceManager.shared.fetch(service: .countries, params: params) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let countires):
                    self.view?.set(countries: countires)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - CountriesPresenterProtocol
}
