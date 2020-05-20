//
//  CountriesContract.swift
//  Countries
//
//  Created by Sergey Krasiuk on 18/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation
import UIKit

protocol CountriesViewProtocol: RoutableProtocol, Alertable {
    
    func set(countries: [Country])
}

protocol CountriesPresenterProtocol {
    
    func fetchCountries(service: NetworkServiceRepresentable)
    func updateFavorites(in countries: [Country])
}

final class Alerts {
    
    enum NetworkAlerts: ActionRepresentable {
        case OK
        case Retry
        
        var rawValue: (title: String, style: UIAlertAction.Style) {
            switch self {
            case .OK:
                return ("OK", .cancel)
            case .Retry:
                return ("Try again", .default)
            }
        }
    }
    
    enum DataAlert: ActionRepresentable {
        case OK
        
        var rawValue: (title: String, style: UIAlertAction.Style) {
            switch self {
            case .OK:
                return ("OK", .default)
            }
        }
    }
}
