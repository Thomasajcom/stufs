//
//  St_GroupGroupSelectorCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 02/11/2020.
//

import UIKit

class St_GroupGroupSelectorCell: UICollectionViewCell {
    static let reuseIdentifier: String = "St_GroupGroupSelectorCell"
    private var button: St_GroupButton! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        button = St_GroupButton(group: nil)
        button.isEnabled = false
    
        contentView.addSubview(button)
    }
    
    private func configureConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            button.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: button.trailingAnchor, multiplier: 1)
        ])
    }
    
    func setupCell(with group: St_Group){
        button.setTitle(group.name, for: .normal)
        button.setButtonColor(to: group.color)
    }
    
     func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.8
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 0
        layer.shadowOpacity = 0.0
        
    }
}
