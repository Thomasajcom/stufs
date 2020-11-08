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
    
    private var nameTextLabel: UILabel! = nil
    private var itemImageView: UIImageView! = nil
    private var warrantyTitle: UILabel! = nil
    private var warrantyTextLabel: UILabel! = nil
    private var acquiredFromTitle: UILabel! = nil
    private var acquiredFromTextLabel: UILabel! = nil
    private var favoriteButton: UIButton! = nil
    
    private var item: St_Item! = nil
    private var name: String! = nil
    private var warrantyLength: Int! = nil
    private var acquiredFrom: String! = nil
    private var favorite: Bool! = nil
    private var itemImage: UIImage! = nil
    
 
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
        warrantyTextLabel.text = "\(item.daysOfWarrantyRemaining)"
        acquiredFromTextLabel.text = item.acquiredFrom
        setColorAndFavoriteButtonImage(to: item.favorite)
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
        nameTextLabel.backgroundColor = .red
        
        warrantyTitle = UILabel()
        warrantyTitle.numberOfLines = 1
        warrantyTitle.font = .preferredFont(forTextStyle: .subheadline)
        warrantyTitle.textColor = .secondaryLabel
        warrantyTitle.text = "Warranty"
        
        warrantyTextLabel = UILabel()
        warrantyTextLabel.numberOfLines = 1
        warrantyTextLabel.font = .preferredFont(forTextStyle: .headline)
        warrantyTextLabel.textColor = .label
        warrantyTextLabel.backgroundColor = .systemBackground
        
        
        acquiredFromTitle = UILabel()
        acquiredFromTitle.numberOfLines = 1
        acquiredFromTitle.font = .preferredFont(forTextStyle: .subheadline)
        acquiredFromTitle.textColor = .secondaryLabel
        acquiredFromTitle.text = "Acquired from"
        
        acquiredFromTextLabel = UILabel()
        acquiredFromTextLabel.numberOfLines = 1
        acquiredFromTextLabel.font = .preferredFont(forTextStyle: .headline)
        acquiredFromTextLabel.textColor = .label
        acquiredFromTextLabel.backgroundColor = .systemBackground
        
        
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(warrantyTitle)
        contentView.addSubview(warrantyTextLabel)
        contentView.addSubview(acquiredFromTitle)
        contentView.addSubview(acquiredFromTextLabel)
    }
    
    private func configureImageView() {
        itemImageView = UIImageView(image: UIImage(named: "St_ItemCell_placeholder"))
        itemImageView.isOpaque = true
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.clipsToBounds = true
        
        contentView.addSubview(itemImageView)
    }
    
    private func configureButtons() {
        favoriteButton = UIButton(type: .custom)
        favoriteButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        
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
        nameTextLabel.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        warrantyTitle.translatesAutoresizingMaskIntoConstraints = false
        warrantyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        acquiredFromTitle.translatesAutoresizingMaskIntoConstraints = false
        acquiredFromTextLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            nameTextLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: nameTextLabel.trailingAnchor, multiplier: 1),
            itemImageView.topAnchor.constraint(equalToSystemSpacingBelow: nameTextLabel.bottomAnchor, multiplier: 1),
            itemImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: itemImageView.bottomAnchor, multiplier: 1),
            warrantyTitle.topAnchor.constraint(equalToSystemSpacingBelow: nameTextLabel.bottomAnchor, multiplier: 1),
            warrantyTitle.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImageView.trailingAnchor, multiplier: 1),
            warrantyTitle.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
            warrantyTextLabel.topAnchor.constraint(equalTo: warrantyTitle.bottomAnchor),
            warrantyTextLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImageView.trailingAnchor, multiplier: 1),
            warrantyTextLabel.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
            acquiredFromTitle.topAnchor.constraint(equalToSystemSpacingBelow: warrantyTextLabel.bottomAnchor, multiplier: 1),
            acquiredFromTitle.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImageView.trailingAnchor, multiplier: 1),
            acquiredFromTitle.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
            acquiredFromTextLabel.topAnchor.constraint(equalTo: acquiredFromTitle.bottomAnchor),
            acquiredFromTextLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImageView.trailingAnchor, multiplier: 1),
            acquiredFromTextLabel.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
            favoriteButton.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            favoriteButton.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImageView.trailingAnchor, multiplier: 1)

        ])
    }
}
