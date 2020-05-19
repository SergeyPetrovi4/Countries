//
//  DetailsViewController.swift
//  Countries
//
//  Created by Sergey Krasiuk on 19/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var countryNativeNameLabel: UILabel!
    @IBOutlet weak var capitalCityLabel: UILabel!
    @IBOutlet weak var timeZonesLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var translationsLabel: UILabel!
    
    var country: Country?
    
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
        
//        self.flagImageView
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
    }

    // MARK: - Actions
    
    @IBAction func didTapAddOrRemoveFavoriteButton(_ sender: UIButton) {
    }
}
