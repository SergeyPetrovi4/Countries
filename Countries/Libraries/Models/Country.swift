//
//  Country.swift
//  Countries
//
//  Created by Sergey Krasiuk on 18/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation

struct Country: Decodable {
    var name: String
    var nativeName: String
    var capital: String
    var population: Int
    var flag: String
    var alpha3Code: String
    var alpha2Code: String
    
    var languages: [Language]
    var timezones: [String]
    
    
    // MARK: - Parsing array of Key/Value
    private var translations: Country.List
    var translatedName: [Translation] {
        return self.translations.values
    }
    
    var hasFavorited: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case name, nativeName, capital, population, flag, languages, timezones, alpha3Code, alpha2Code, translations
    }
}

extension Country {

    struct List: Decodable {
        let values: [Translation]

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let dictionary = try container.decode([String : String].self)

            values = dictionary.map { key, value in
                Translation(country: key, translation: value)
            }
        }
    }
}
