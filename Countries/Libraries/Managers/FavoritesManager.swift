//
//  FavoritesManager.swift
//  GeoNamesWiki
//
//  Created by Sergey Krasiuk on 05/11/2019.
//  Copyright © 2019 Sergey Krasiuk. All rights reserved.
//

import Foundation
import CoreData

class FavoritesManager {
    
    static let shared = FavoritesManager()
    private let key = "com.country.favorites"
    private init() {}
    
    // MARK: - Retrive favorites
    
    var favorites: [String] {
        return UserDefaults.standard.array(forKey: self.key) as? [String] ?? [String]()
    }
        
    // MARK: - Save favorite
    
    func append(favorite id: String) {
        
        var favorites = self.favorites
        favorites.append(id)
        self.update(elements: favorites)
    }
    
    func remove(favorite id: String) {
        
        if !self.favorites.isEmpty {
            
            let elements = self.favorites.filter({ $0 != id })
            self.update(elements: elements)
            return
        }
        
        print("Favorites: Nothing to remove from db!")
    }
    
    func isExist(favorite id: String) -> Bool {
        return !self.favorites.filter({ $0 == id }).isEmpty
    }
    
    // MARK: - Private
    
    private func update(elements: [String]) {
        UserDefaults.standard.set(elements, forKey: self.key)
        UserDefaults.standard.synchronize()
    }
}
