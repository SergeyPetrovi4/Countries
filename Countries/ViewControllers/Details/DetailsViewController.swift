//
//  DetailsViewController.swift
//  Countries
//
//  Created by Sergey Krasiuk on 19/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import UIKit

protocol DetailsDelegate {
    func update(country: Country)
}

class DetailsViewController: UIViewController {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryNativeNameLabel: UILabel!
    @IBOutlet weak var capitalCityLabel: UILabel!
    @IBOutlet weak var timeZonesLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var translationsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var country: Country?
    var hasFavorited: Bool = false
    var delegate: DetailsDelegate?
    var type: CountriesTableViewController.CountriesType = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Country details"
        self.setupUI()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        
        guard let passedCountry = self.country else {
            print("Error passing data of country!")
            return
        }
        
        // MARK: - Using another service for showing flag of country
        let countryAbbreviature = passedCountry.alpha2Code.lowercased()
        if let url = URL(string: "https://www.countryflags.io/\(countryAbbreviature)/flat/64.png") {
            self.flagImageView.kf.setImage(with: url)
        }

        self.countryNameLabel.attributedText = NSMutableAttributedString().bold("Country: ").normal("\(passedCountry.name)", color: .black)
        self.countryNativeNameLabel.attributedText = NSMutableAttributedString().bold("Native name: ").normal("\(passedCountry.nativeName)", color: .black)
        self.capitalCityLabel.attributedText = NSMutableAttributedString().bold("Capital city: ").normal("\(passedCountry.capital)", color: .black)
        
        let timeZones = passedCountry.timezones.joined(separator: ", ")
        self.timeZonesLabel.attributedText = NSMutableAttributedString().bold("Time zones: ").normal("\(timeZones)", color: .black)
        self.populationLabel.attributedText = NSMutableAttributedString().bold("Population: ").normal("\(passedCountry.population)", color: .black)
        
        let languages = "\n" + passedCountry.languages.map({ "\($0.name): \($0.nativeName)" }).joined(separator: "\n")
        self.languagesLabel.attributedText = NSMutableAttributedString().bold("Languages: ").normal("\(languages)", color: .black)
        
        let translations = "\n" + passedCountry.translatedName.map({ "\($0.country): \($0.translation)" }).joined(separator: "\n")
        self.translationsLabel.attributedText = NSMutableAttributedString().bold("Translations: ").normal("\(translations)", color: .black)
        
        self.capitalCityLabel.isHidden = passedCountry.capital.isEmpty
        
        self.updateButtonState()
    }
    
    private func updateButtonState() {
        
        guard let passedCountry = self.country else {
            print("Error passing data of country!")
            return
        }
        
        self.hasFavorited = FavoritesManager.shared.isExist(favorite: passedCountry.alpha3Code)
        self.favoriteButton.setTitle(self.hasFavorited ? "Remove from Favorites" : "Add to Favorites", for: .normal)
    }

    // MARK: - Actions
    
    @IBAction func didTapAddOrRemoveFavoriteButton(_ sender: UIButton) {
        
        guard let passedCountry = self.country else {
            print("Error passing data of country!")
            return
        }
        
        if self.type == .favorites {
            // When you on screen Favorites and remove Item from favorites,
            // you can`t add again to favorites, bacause object was removed
            // from favorites list of screen Favorites
            self.favoriteButton.isHidden = true
        }
        
        if self.hasFavorited {
            FavoritesManager.shared.remove(favorite: passedCountry.alpha3Code)
            self.updateButtonState()
            self.delegate?.update(country: passedCountry)
            return
        }
        
        FavoritesManager.shared.append(favorite: passedCountry.alpha3Code)
        self.updateButtonState()
        self.delegate?.update(country: passedCountry)
    }
}
