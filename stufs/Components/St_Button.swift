//
//  St_Button.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 01/12/2020.
//

import UIKit

/// A custom UIButton that defines a button in a set style, hardcoded to be placed on the right side of the screen
class St_Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureColors()
        configureBorder()
        configureShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configureColors() {
        backgroundColor = .St_primaryColor
        tintColor = .white
    }
    
    private func configureBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 5
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 30)
    }
    
    private func configureShadow() {
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.95
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
