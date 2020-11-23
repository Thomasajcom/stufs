//
//  St_GroupGroupSelectorCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 02/11/2020.
//

import UIKit

class St_GroupGroupSelectorCell: UICollectionViewCell {
    static let reuseIdentifier: String = "St_GroupGroupSelectorCell"
    private var label: UILabel! = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel() {
        label = UILabel()
        
        //text configuration
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.allowsDefaultTighteningForTruncation = true
        //coloring
        label.textColor = .label
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
        addBorder()
        
        contentView.addSubview(label)
    }
    
    
    private func configureConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: label.trailingAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: label.bottomAnchor, multiplier: 1)
        ])
    }
    
    func setupCell(with group: St_Group){
        label.text = group.name
        label.backgroundColor = group.color

    }
    
    private func addBorder() {
        
    }
    
     func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
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
