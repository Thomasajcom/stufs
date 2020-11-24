//
//  St_ItemCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 19/10/2020.
//

import UIKit

/// The Cell that displays the Item in the primary List View (collectionview) of the app
class St_ItemCell: UICollectionViewCell {
    static let reuseIdentifier: String = "St_ItemCell"
    
    private var nameTextLabel: St_Label! = nil
    private var itemImageView: UIImageView! = nil
    private var warrantyTitle: St_Label! = nil
    private var warrantyTextLabel: St_Label! = nil
    private var itemAgeTitle: St_Label! = nil
    private var itemAgeTextLabel: St_Label! = nil
    private var acquiredFromTitle: St_Label! = nil
    private var acquiredFromTextLabel: St_Label! = nil
    private var favoriteButton: UIButton! = nil
    
    private var item: St_Item! = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLabels()
        configureImageView()
        configureButtons()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure
    func configureCell(for item: St_Item) {
        self.item = item
        nameTextLabel.text = item.name
        warrantyTextLabel.text = "( item.acquiredWhen+\(item.warrantyLength) ) - idag = x days left"
        acquiredFromTextLabel.text = item.acquiredFrom
        itemAgeTextLabel.text = "\(item.getItemAge()) days"
        setColorAndFavoriteButtonImage(to: item.favorite)
    }
    
    private func configureView() {
        backgroundColor = .St_ItemCellBackgroundColor
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.nonselectedTabColor?.cgColor
    }
    
    private func configureLabels() {
        nameTextLabel = St_Label(textStyle: .largeTitle)
        nameTextLabel.text = "nameTextLabel"
        
        warrantyTitle = St_Label(textStyle: .subheadline)
        warrantyTitle.text = "Warranty expires in"
        
        warrantyTextLabel = St_Label(textStyle: .headline)
        
        itemAgeTitle = St_Label(textStyle: .subheadline)
        itemAgeTitle.text = "Age"
        
        itemAgeTextLabel = St_Label(textStyle: .headline)
        itemAgeTextLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        acquiredFromTitle = St_Label(textStyle: .subheadline)
        acquiredFromTitle.text = "Acquired from"
        
        acquiredFromTextLabel = St_Label(textStyle: .headline)
        acquiredFromTextLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        contentView.addSubview(nameTextLabel)
        contentView.addSubview(warrantyTitle)
        contentView.addSubview(warrantyTextLabel)
        contentView.addSubview(itemAgeTitle)
        contentView.addSubview(itemAgeTextLabel)
        contentView.addSubview(acquiredFromTitle)
        contentView.addSubview(acquiredFromTextLabel)
    }
    
    private func configureImageView() {
//        itemImageView = UIImageView(image: UIImage(named: "St_ItemCell_placeholder"))
        itemImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        itemImageView.image = UIImage(named: "St_ItemCell_placeholder")
        itemImageView.isOpaque = true
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        
        contentView.addSubview(itemImageView)
    }
    
    private func configureButtons() {
        favoriteButton = UIButton(type: .custom)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        
        contentView.addSubview(favoriteButton)
    }
    
    private func setColorAndFavoriteButtonImage(to value: Bool) {
        favoriteButton.tintColor = value ? .yellow : .label
        favoriteButton.setImage(value ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), for: .normal)
    }
    
    // MARK: - Actions
    @objc func toggleFavorite(sender: UIButton) {
        item.toggleFavoriteStatus()
        setColorAndFavoriteButtonImage(to: item.favorite)
    }
    
    
    // MARK: - CONSTRAINTS
    private func configureConstraints() {
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            nameTextLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            nameTextLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
//            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: favoriteButton.trailingAnchor, multiplier: 1),

            
            itemImageView.heightAnchor.constraint(equalToConstant: 100),
            itemImageView.widthAnchor.constraint(equalToConstant: 100),
            itemImageView.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor),
            itemImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: itemImageView.bottomAnchor, multiplier: 1),
            
            warrantyTitle.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor),
            warrantyTitle.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImageView.trailingAnchor, multiplier: 1),
            warrantyTitle.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
            warrantyTextLabel.topAnchor.constraint(equalTo: warrantyTitle.bottomAnchor),
            warrantyTextLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImageView.trailingAnchor, multiplier: 1),
            warrantyTextLabel.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
            
            itemAgeTitle.topAnchor.constraint(equalToSystemSpacingBelow: warrantyTextLabel.bottomAnchor, multiplier: 1),
            itemAgeTitle.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImageView.trailingAnchor, multiplier: 1),
            itemAgeTitle.bottomAnchor.constraint(lessThanOrEqualTo: itemAgeTextLabel.topAnchor),
            itemAgeTextLabel.topAnchor.constraint(equalTo: acquiredFromTitle.bottomAnchor),
            itemAgeTextLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImageView.trailingAnchor, multiplier: 1),
            itemAgeTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

            acquiredFromTitle.topAnchor.constraint(equalToSystemSpacingBelow: warrantyTextLabel.bottomAnchor, multiplier: 1),
            acquiredFromTitle.leadingAnchor.constraint(equalToSystemSpacingAfter: itemAgeTextLabel.trailingAnchor, multiplier: 1),
            acquiredFromTitle.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
            acquiredFromTextLabel.topAnchor.constraint(equalTo: acquiredFromTitle.bottomAnchor),
            acquiredFromTextLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: itemAgeTextLabel.trailingAnchor, multiplier: 1),
            acquiredFromTextLabel.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
            acquiredFromTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
}
