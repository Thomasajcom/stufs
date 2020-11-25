//
//  St_GroupButton.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 29/10/2020.
//

import UIKit


class St_ReceiptButton: UIButton {
    
    
    convenience init() {
        self.init(type: .custom)
        setTitle("Receipt", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .St_primaryColor
        translatesAutoresizingMaskIntoConstraints = false
        configureBorder()
    }
    
    // MARK: - Configure
    private func configureBorder() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 5
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
