//
//  St_AddItemImageCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 22/10/2020.
//

import UIKit

enum St_AddItemImage {
    case item
    case receipt
}

protocol St_AddItemImageCellDelegate {
    func showImagePicker(for imageType: St_AddItemImage)
}

/// A Cell for adding images, both of an item and a receipt, to a new item when Adding Item
class St_AddItemImageCell: UITableViewCell {
    static let reuseIdentifier: String = "St_AddItemImageCell"
    var addItemImageDelegate: St_AddItemImageCellDelegate?
    
    private var itemLabel: UILabel! = nil
    var itemImage: UIImageView! = nil
    
    private var receiptLabel: UILabel! = nil
    var receiptImage: UIImageView! = nil
    
    private var imagePicker: UIImagePickerController! = nil
    
    private var labelStack: UIStackView! = nil
    private var photoStack: UIStackView! = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.preservesSuperviewLayoutMargins = true
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
        
        receiptLabel = UILabel()
        receiptLabel.textColor = .label
        receiptLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        itemLabel.text = "Item"
        receiptLabel.text = "Receipt"
    }
    
    private func configureImageViews() {
        itemImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        receiptImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        itemImage.image = UIImage(named: "St_ItemCell_placeholder")
        receiptImage.image = UIImage(named: "St_ItemCell_placeholder")
        self.attachGestureRecognizer(to: itemImage, with: #selector(addItemImage))
        self.attachGestureRecognizer(to: receiptImage, with: #selector(addReceiptImage))
    }
    
    private func configureStackViews() {
        labelStack = UIStackView(arrangedSubviews: [itemLabel, receiptLabel])
        labelStack.axis = .horizontal
        labelStack.alignment = .leading
        labelStack.distribution = .fillEqually
        
        photoStack = UIStackView(arrangedSubviews: [itemImage, receiptImage])
        photoStack.axis = .horizontal
        photoStack.alignment = .center
        photoStack.distribution = .fillEqually
        photoStack.spacing = 10

        contentView.addSubview(labelStack)
        contentView.addSubview(photoStack)
    }
    
    private func configureDivider() {
        
    }
    
    // MARK: - Constraints
    private func configureConstraints() {
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        photoStack.translatesAutoresizingMaskIntoConstraints = false
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        receiptImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            labelStack.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: labelStack.trailingAnchor, multiplier: 1),
            photoStack.topAnchor.constraint(equalToSystemSpacingBelow: labelStack.bottomAnchor, multiplier: 1),
            photoStack.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: photoStack.trailingAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: photoStack.bottomAnchor, multiplier: 1)
        ])
    }
    
    // MARK: - Actions
    @objc func addItemImage() {
        print("button presssseesdd!")
        addItemImageDelegate?.showImagePicker(for: .item)
    }
    
    @objc func addReceiptImage() {
        addItemImageDelegate?.showImagePicker(for: .receipt)
    }
    
    // MARK: - Helper Functions
    func attachGestureRecognizer(to imageView: UIImageView, with action: Selector) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: action)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)
    }
    
    
}
