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
    private var label: UILabel! = nil
    
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
        
        label = UILabel()
        label.backgroundColor = .St_primaryColor
        label.textColor = .white
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .callout)
        contentView.addSubview(button)
    }
    
    private func configureConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: button.trailingAnchor, multiplier: 1)
        ])
    }
    
    func setupCell(with group: St_Group){
        button.setTitle(group.name, for: .normal)
        button.setButtonColor(to: group.color)
//        label.text = group.name
//        label.backgroundColor = group.color
    }
}
