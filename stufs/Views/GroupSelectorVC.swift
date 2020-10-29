//
//  GroupSelectorVC.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 29/10/2020.
//

import UIKit
import CoreData

class GroupSelectorVC: UIViewController {
    
    private var group: St_Group?
    private var coreDataStore: St_CoreDataStore! = nil
    
    private var cardView = UIView()
    private var titleLabel: UILabel! = nil
    private var infoLabel: UILabel! = nil
    private var nameLabel: UILabel! = nil
    private var nameTextField: UITextField! = nil
    private var buttonStack: UIStackView! = nil
    private var cancelButton: UIButton! = nil
    private var okButton: UIButton! = nil
    
    init(coreDataStore: St_CoreDataStore, group: St_Group?) {
        super.init(nibName: nil, bundle: nil)
        self.coreDataStore = coreDataStore
        self.group = group
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLabels()
        configureTextField()
        configureButtons()
        configureConstraints()
        
    }
    
    
    // MARK: - Configure
    private func configureView() {
        view.backgroundColor = .clear
        cardView.bounds.size.width = view.bounds.width - 100
        cardView.bounds.size.height = view.bounds.height / 2
        cardView.center = view.center
        cardView.alpha = 1
        cardView.backgroundColor = .systemBackground
        
        view.addSubview(cardView)
    }
    
    // MARK:  ConfigureLabels
    private func configureLabels() {
        titleLabel = UILabel()
        titleLabel.backgroundColor = .St_primaryColor
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        
        infoLabel = UILabel()
        infoLabel.textColor = .secondaryLabel
        infoLabel.numberOfLines = 0
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.minimumScaleFactor = 0.7
        infoLabel.font = .preferredFont(forTextStyle: .footnote)
        
        
        nameLabel = UILabel()
        nameLabel.textColor = .label
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        
        
        titleLabel.text = "Group"
        infoLabel.text = "Grouping items makes them easier to find. Try to be descriptive, e.g. \"Electronics\", \"Board Games\" or \"Clothes\"! "
        nameLabel.text = "Name:"


        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
        view.addSubview(nameLabel)
    }
    
    // MARK: - ConfigureTextField
    private func configureTextField() {
        nameTextField = UITextField()
        nameTextField.delegate = self
        nameTextField.textAlignment = .right
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.adjustsFontSizeToFitWidth = true
        nameTextField.enablesReturnKeyAutomatically = true
        
        nameTextField.placeholder = "New Group"
        view.addSubview(nameTextField)
    }
    
    // MARK: - ConfigureButtons
    private func configureButtons() {
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        okButton = UIButton(type: .custom)
        okButton.setTitle("Create Group", for: .normal)
        okButton.setTitleColor(.secondaryLabel, for: .normal)
        okButton.addTarget(self, action: #selector(setGroup), for: .touchUpInside)
        
        buttonStack = UIStackView(arrangedSubviews: [cancelButton, okButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
    }
    
    // MARK: - ConfigureConstraints
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            infoLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            infoLabel.leadingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.trailingAnchor),
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: infoLabel.bottomAnchor, multiplier: 1),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leadingAnchor),
            nameTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 1),
            nameTextField.trailingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.trailingAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
            
        ])
    }
    
    // we add this to enable the removal of the keyboard by pressing outside the nameTextField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Actions
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// This either creates a new group, or sets an already existing group based on collectionView selection
    @objc func setGroup() {
        //if collectview.selectedGroup == nil
        if nameTextField.text?.isEmpty == false {
            let newGroup = St_Group(context: coreDataStore.persistentContainer.viewContext)
            newGroup.name = nameTextField.text!
            //select random color from approved colors
            newGroup.color = UIColor.red
            
            coreDataStore.saveContext()
            
        }
        #warning("Alert user about Saved Group")
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate
extension GroupSelectorVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == false {
            okButton.setTitleColor(.St_primaryColor, for: .normal)
        } else {
            okButton.setTitleColor(.secondaryLabel, for: .normal)
        }
    }
}
