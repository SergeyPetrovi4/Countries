//
//  CountriesService.swift
//  Countries
//
//  Created by Sergey Krasiuk on 20/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation

protocol NetworkServiceRepresentable  {
    var rawValue: (String) { get }
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
