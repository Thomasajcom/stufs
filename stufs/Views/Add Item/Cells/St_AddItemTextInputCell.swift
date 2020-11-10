//
//  TextTableViewCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 22/10/2020.
//

import UIKit

enum TextFieldIdentifier: String {
    case itemName = "Name:"
    case acquiredFrom = "From:"
}
protocol St_AddItemTextInputCellDelegate: class {
    func textFieldWasSet(to name: String, for textField: TextFieldIdentifier)
}
/// A Cell for adding text to a new item when Adding Item. The cell displays a title and a textfield with a placeholder.
class St_AddItemTextInputCell: UITableViewCell {
    static let reuseIdentifier = "St_AddItemTextInputCell"
    
    private var titleLabel: UILabel! = nil
    var textField: UITextField! = nil
    weak var addItemTextInputDelegate: St_AddItemTextInputCellDelegate?
    var textFieldIdentifier: TextFieldIdentifier?
    
    
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
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        contentView.endEditing(true)
//    }
    
    // MARK: - Configure
    private func configureLabel() {
        titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.text = "Name:"
        titleLabel.textColor = .label
        
        contentView.addSubview(titleLabel)
    }
    
    private func configureTextField() {
        textField = UITextField()
        textField.delegate = self
        textField.clearsOnBeginEditing = true
        textField.textAlignment = .right
        textField.clearButtonMode = .whileEditing
        textField.adjustsFontSizeToFitWidth = true
        textField.enablesReturnKeyAutomatically = true
        
        
        contentView.addSubview(textField)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            textField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textField.leadingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: textField.bottomAnchor, multiplier: 1),
        ])
    }
    
    // MARK: -setUpCell
    func setUpCell(id: TextFieldIdentifier, placeholder: String) {
        textFieldIdentifier = id
        titleLabel.text = id.rawValue
        textField.placeholder = placeholder
    }

}

// MARK: - UITextFieldDelegate
extension St_AddItemTextInputCell: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textFieldIdentifier != nil {
            addItemTextInputDelegate?.textFieldWasSet(to: textField.text!, for: textFieldIdentifier!)
        }
        return true
    }
}


