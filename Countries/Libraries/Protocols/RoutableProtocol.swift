//
//  RoutableViewControllerProtocol.swift
//  Meuhedet
//
//  Created by Sergey Krasiuk on 17/04/2018.
//  Copyright © 2018 Sergey Krasiuk. All rights reserved.
//

import UIKit

protocol RoutableProtocol {
    
    // MARK: - Pop`s
    
    func pop()
    
    // MARK: - Details
    
    func showDetails(ofCountry country: Country)
}

extension RoutableProtocol where Self: UIViewController {
    
    // MARK: - Pop`s
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Details
    
    func showDetails(ofCountry country: Country) {
        
        let detailsViewController = DetailsViewController.instantiateFrom(storyboard: .main)
        detailsViewController.country = country
        self.show(detailsViewController, sender: nil)
    }
}

