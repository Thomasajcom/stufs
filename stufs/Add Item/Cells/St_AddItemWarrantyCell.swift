//
//  St_AddItemWarrantyCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 02/11/2020.
//

import UIKit

protocol St_AddItemWarrantyCellDelegate {
    func goToWarrantyPicker()
}

/// A Cell for adding information on Warranty to an item. Opens a picker with predefined values
class St_AddItemWarrantyCell: UITableViewCell {
    static let reuseIdentifier = "St_AddItemWarrantyCell"

    private var titleLabel: UILabel! = nil
    var textField: UITextField! = nil
    var warrantyDelegate: St_AddItemWarrantyCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLabel()
        configureTextField()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // we add this to enable the removal of the keyboard by pressing outside the nameTextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentView.endEditing(true)
    }
    
    // MARK: - Configure
    private func configureLabel() {
        titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.text = "Warranty:"
        titleLabel.textColor = .label
        
        contentView.addSubview(titleLabel)
    }
    
    private func configureTextField() {
        textField = UITextField()
        textField.delegate = self
        textField.clearsOnBeginEditing = true
        textField.textAlignment = .right
        textField.clearButtonMode = .whileEditing
        textField.enablesReturnKeyAutomatically = true
        textField.keyboardType = .numberPad
        
        
        contentView.addSubview(textField)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: -setUpCell
    func setUpCell(title: String, placeholder: String) {
        titleLabel.text = title
        textField.placeholder = placeholder
    }
    
    /// when a waranty is set, the textfield must reflect this
    func setWarrantyLength(days: Int) {
        textField.text = "Expires in \(days) days"
    }
}

// MARK: - UITextFieldDelegate
extension St_AddItemWarrantyCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        warrantyDelegate?.goToWarrantyPicker()
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


