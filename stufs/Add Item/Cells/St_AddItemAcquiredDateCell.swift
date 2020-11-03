//
//  St_AddItemAcquiredDateCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 02/11/2020.
//

import UIKit

class St_AddItemAcquiredDateCell: UITableViewCell {
    static let reuseIdentifier: String = "St_AddItemAcquiredDateCell"
    
    private var titleLabel: UILabel! = nil
    var datePicker: UIDatePicker! = nil

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLabel()
        configureDatePicker()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configureLabel() {
        titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.text = "When:"
        titleLabel.textColor = .label
        
        contentView.addSubview(titleLabel)
    }
    
    private func configureDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date

        contentView.addSubview(datePicker)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            datePicker.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentView.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: datePicker.bottomAnchor, multiplier: 1),
        ])
    }
    
    // MARK: -setUpCell
    func setUpCell(title: String, placeholder: String) {
        titleLabel.text = title
    }

}

