//
//  St_ItemCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 19/10/2020.
//

import UIKit

class St_ItemCell: UICollectionViewCell {
    static let reuseIdentifier: String = "St_ItemCell"
    
    private var nameTextLabel: UILabel! = nil
    private var warrantyLabel: UILabel! = nil
    private var warrantyTextLabel: UILabel! = nil
    private var itemImageView: UIImageView! = nil
    
    private var name: String! = nil
    private var warrantyLength: Int! = nil
    private var acquiredDate: Date! = nil
    private var acquiredFrom: String! = nil
    private var favorite: Bool! = nil
    private var itemImage: UIImage! = nil
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLabels()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure
    func configureCell(for item: St_Item) {
        nameTextLabel.text = item.name
    }
    
    private func configureView() {
        backgroundColor = .St_ItemCellBackgroundColor
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.nonselectedTabColor?.cgColor
    }
    
    private func configureLabels() {
        nameTextLabel = UILabel()
        nameTextLabel.numberOfLines = 1
        nameTextLabel.font = .preferredFont(forTextStyle: .largeTitle)
        nameTextLabel.adjustsFontForContentSizeCategory = true
        nameTextLabel.textColor = .label
        
        contentView.addSubview(nameTextLabel)
    }
    
    private func configureConstraints() {
        nameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            nameTextLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: nameTextLabel.trailingAnchor, multiplier: 1)
        ])
    }
}
