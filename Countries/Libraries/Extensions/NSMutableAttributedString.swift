//
//  NSMutableAttributedString.swift
//  Countries
//
//  Created by Sergey Krasiuk on 19/05/2020.
//  Copyright © 2020 Sergey Krasiuk. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    var fontSize: CGFloat {
        return UIFont.labelFontSize
    }
    
    var boldFont: UIFont {
        return  UIFont.boldSystemFont(ofSize: fontSize)
    }
    
    var normalFont: UIFont {
        return  UIFont.systemFont(ofSize: fontSize)
    }

    func bold(_ value: String, color: UIColor = .link) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont,
            .foregroundColor: color
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String, color: UIColor = .link) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
            .foregroundColor: color
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
