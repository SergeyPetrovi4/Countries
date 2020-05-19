//
//  CoutryViewCell.swift
//  Countries
//
//  Created by Sergey Krasiuk on 18/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import UIKit
import Kingfisher

class CountryViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var capitalCity: UILabel!
    @IBOutlet weak var timeZone: UILabel!

    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.selectionStyle = .none
    }
    
    // MARK: - Configuration
    
    func configure(with country: Country) {
        
        self.name.attributedText = NSMutableAttributedString()
                                    .bold("Country: ")
                                    .normal("\(country.name)", color: .black)
        
        self.capitalCity.isHidden = country.capital.isEmpty
        self.capitalCity.attributedText = NSMutableAttributedString()
                                            .bold("Capital city: ")
                                            .normal("\(country.capital)", color: .black)
        
        let timeZones = country.timezones.joined(separator: ", ")
        self.timeZone.text = "Time zones: \(timeZones)"
        
        // MARK: - Using another service for showing flag of country
        let countryAbbreviature = country.alpha2Code.lowercased()
        if let url = URL(string: "https://www.countryflags.io/\(countryAbbreviature)/flat/64.png") {
            self.flag.kf.setImage(with: url)
        }
    }
    
    // MARK: - Action
    
    @IBAction func didTapAddRemoveFavoriteButton(_ sender: UIButton) {
    }    
}
