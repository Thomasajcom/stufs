//
//  St_AddItemImageCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 22/10/2020.
//

import UIKit

/// A Cell for adding images, both of an item and a receipt, to a new item when Adding Item
class St_AddItemImageCell: UITableViewCell {
    static let reuseIdentifier: String = "St_AddItemImageCell"
    
    private var itemLabel: UILabel! = nil
    private var receiptLabel: UILabel! = nil
    private var itemImage: UIImageView! = nil
    private var receiptImage: UIImageView! = nil
    
    private var itemStack: UIStackView! = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLabels()
        configureImageViews()
        configureDivider()
        configureStackViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configureLabels() {
        itemLabel = UILabel()
        itemLabel.textColor = .label
        itemLabel.font = .preferredFont(forTextStyle: .subheadline)
        itemLabel.text = "Item"
        itemLabel.textAlignment = .left
        
        receiptLabel = UILabel()
        receiptLabel.textColor = .label
        receiptLabel.font = .preferredFont(forTextStyle: .subheadline)
        receiptLabel.text = "Item"
        
//        contentView.addSubview(itemLabel)
//        contentView.addSubview(receiptLabel)
    }
    
    private func configureImageViews() {
        itemImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        itemImage.image = UIImage(systemName: "plus")
        
//        contentView.addSubview(itemImage)
    }
    
    private func configureStackViews() {
        itemStack = UIStackView(arrangedSubviews: [itemLabel,itemImage])
        itemStack.axis = .vertical
        itemStack.alignment = .fill
        itemStack.distribution = .fillProportionally
        
        contentView.addSubview(itemStack)
        
    }
    
    private func configureDivider() {
        
    }
    
    // MARK: - Constraints
    private func configureConstraints() {
        itemStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemStack.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            itemStack.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
