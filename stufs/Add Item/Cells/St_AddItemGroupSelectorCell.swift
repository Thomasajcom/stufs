//
//  St_AddItemGroupSelectorCell.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 29/10/2020.
//

import UIKit

protocol St_AddItemGroupSelectorCellDelegate {
    func goToGroupSelection(group: St_Group?)
}

class St_AddItemGroupSelectorCell: UITableViewCell {
    static let reuseIdentifier = "St_AddItemGroupSelectorCell"
    
    private var titleLabel: UILabel! = nil
    private var selectGroupButton: St_GroupButton! = nil
    var groupDelegate: St_AddItemGroupSelectorCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLabel()
        configureButton()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configureLabel() {
        titleLabel = UILabel()
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        
        titleLabel.text = "Group:"
        
        contentView.addSubview(titleLabel)
    }
    
    private func configureButton() {
        selectGroupButton = St_GroupButton(group: nil)
        selectGroupButton.addTarget(self, action: #selector(goToGroupSelection), for: .touchUpInside)
        
        contentView.addSubview(selectGroupButton)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectGroupButton.leadingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1),
            selectGroupButton.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            selectGroupButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
    /// when a group is set, the button must be styled like the group
    func set(group: St_Group) {
        selectGroupButton.setTitle(group.name, for: .normal)
        selectGroupButton.setButtonColor(to: group.color)
    }
    
    // MARK: - Action
    @objc func goToGroupSelection(sender: St_GroupButton) {
        groupDelegate?.goToGroupSelection(group: sender.selectedGroup)
    }
}
