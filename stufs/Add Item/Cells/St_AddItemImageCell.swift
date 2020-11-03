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
    private var addImageButton: UIButton! = nil
    var itemImage: UIImageView! = nil
    
    private var receiptLabel: UILabel! = nil
    private var addReceiptButton: UIButton! = nil
    var receiptImage: UIImageView! = nil
    
    private var imagePicker: UIImagePickerController! = nil
    
    private var labelStack: UIStackView! = nil
    private var photoStack: UIStackView! = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.preservesSuperviewLayoutMargins = true
        configureLabels()
        configureImageButtons()
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
    
    private func configureImageButtons() {
        addImageButton = UIButton(type: .custom)
        addImageButton.setImage(UIImage(systemName: "camera"), for: .normal)
        addImageButton.addTarget(self, action: #selector(addItemImage), for: .touchUpInside)
        addImageButton.tintColor = .St_primaryColor
        
        addReceiptButton = UIButton(type: .custom)
        addReceiptButton.setImage(UIImage(systemName: "camera"), for: .normal)
        addReceiptButton.addTarget(self, action: #selector(addReceiptImage), for: .touchUpInside)
        addReceiptButton.tintColor = .St_primaryColor
        
        contentView.addSubview(addImageButton)
        contentView.addSubview(addReceiptButton)
    }
    
    private func configureImageViews() {
        itemImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        receiptImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        itemImage.isHidden = true
        receiptImage.isHidden = true
        contentView.addSubview(itemImage)
        contentView.addSubview(receiptImage)
    }
    
    private func configureStackViews() {
        labelStack = UIStackView(arrangedSubviews: [itemLabel, receiptLabel])
        labelStack.axis = .horizontal
        labelStack.alignment = .leading
        labelStack.distribution = .fillEqually

        contentView.addSubview(labelStack)
    }
    
    private func configureDivider() {
        
    }
    
    // MARK: - Constraints
    private func configureConstraints() {
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        receiptImage.translatesAutoresizingMaskIntoConstraints = false
        addReceiptButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            labelStack.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: labelStack.trailingAnchor, multiplier: 1),
            addImageButton.topAnchor.constraint(equalToSystemSpacingBelow: labelStack.bottomAnchor, multiplier: 1),
            addImageButton.centerXAnchor.constraint(equalToSystemSpacingAfter: itemLabel.centerXAnchor, multiplier: 1),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: addImageButton.bottomAnchor, multiplier: 1),
            itemImage.topAnchor.constraint(equalToSystemSpacingBelow: labelStack.bottomAnchor, multiplier: 1),
            itemImage.centerXAnchor.constraint(equalToSystemSpacingAfter: itemLabel.centerXAnchor, multiplier: 1),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: itemImage.bottomAnchor, multiplier: 1),
            addReceiptButton.topAnchor.constraint(equalToSystemSpacingBelow: labelStack.bottomAnchor, multiplier: 1),
            addReceiptButton.centerXAnchor.constraint(equalToSystemSpacingAfter: receiptLabel.centerXAnchor, multiplier: 1),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: addReceiptButton.bottomAnchor, multiplier: 1),
            receiptImage.topAnchor.constraint(equalToSystemSpacingBelow: labelStack.bottomAnchor, multiplier: 1),
            receiptImage.centerXAnchor.constraint(equalToSystemSpacingAfter: receiptLabel.centerXAnchor, multiplier: 1),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: receiptImage.bottomAnchor, multiplier: 1),
            itemImage.widthAnchor.constraint(equalTo: itemImage.heightAnchor, multiplier: 4/3),
            receiptImage.widthAnchor.constraint(equalTo: receiptImage.heightAnchor, multiplier: 4/3),
            
            
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
    
}
