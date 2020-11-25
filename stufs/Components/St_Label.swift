//
//  St_Label.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 24/11/2020.
//

import UIKit

class St_Label: UILabel {
    
    convenience init(textStyle: UIFont.TextStyle) {
        self.init()
        numberOfLines = 1
        font = .preferredFont(forTextStyle: textStyle)
        adjustsFontSizeToFitWidth = true
        adjustsFontForContentSizeCategory = true
        translatesAutoresizingMaskIntoConstraints = false
        
        switch textStyle {
        case .largeTitle:
            textColor = .label
//            backgroundColor = .green
        case .headline:
            textColor = .label
            backgroundColor = .systemBackground
        case .subheadline:
            textColor = .secondaryLabel
        default:
            textColor = .red
        }
    }

}
