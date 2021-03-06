//
//  St_GroupButton.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 29/10/2020.
//

import UIKit

/// A Button showing the item's currently selected Group
/// When there is no selected Group for an item, which only should be allowed when creating a new item, the button displays a text urging user to tap it.
class St_GroupButton: UIButton {
    
    var selectedGroup: St_Group?
    
    convenience init(group: St_Group?) {
        self.init(type: .custom)
        if let selectedGroup = group {
            self.selectedGroup = selectedGroup
            setTitle(selectedGroup.name, for: .normal)
            setTitleColor(selectedGroup.color, for: .normal)
        } else {
            setTitle("Select Group", for: .normal)
            setTitleColor(.label, for: .normal)
            backgroundColor = .systemRed

        }
        translatesAutoresizingMaskIntoConstraints = false
        
        configureBorder()
//        configureShadow()
        
    }
    
    // MARK: - Configure
    private func configureBorder() {
        layer.borderWidth = 1
        #warning("Bordercolor needs to set the Group Color property first, then default to another color if selectedGroup is nil")
        layer.borderColor = UIColor.red.cgColor
        layer.cornerRadius = 5
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    private func configureShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.8
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    // MARK: - Public config
    func setButtonColor(to color: UIColor) {
        layer.borderColor = color.cgColor
        backgroundColor = color

    }
    
}
