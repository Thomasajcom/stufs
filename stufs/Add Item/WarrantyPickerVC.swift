//
//  WarrantyPickerVC.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 02/11/2020.
//

import UIKit

class WarrantyPickerVC: UIViewController {
    
    var warrantyPickerDelegate: WarrantyPickerVCDelegate?
    private var cardView = UIView()
    private var titleLabel: UILabel! = nil
    private var infoLabel: UILabel! = nil
    private var numberPicker: UIPickerView! = nil
    private var numberPickerDataSource: [WarrantyLength]! = nil
    
    private var buttonStack: UIStackView! = nil
    private var cancelButton: UIButton! = nil
    private var okButton: UIButton! = nil
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLabels()
        configurePicker()
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
        
        titleLabel.text = "Warranty"
        infoLabel.text = "Select the length of the item's warranty."

        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
    }
    
    // MARK: - ConfigurePicker
    private func configurePicker() {
        numberPicker = UIPickerView()
        numberPicker.delegate = self
        numberPicker.dataSource = self
        numberPickerDataSource = [WarrantyLength]()
        numberPickerDataSource.append(WarrantyLength(length: 90, timeUnit: .days))
        numberPickerDataSource.append(WarrantyLength(length: 3, timeUnit: .years))
        numberPickerDataSource.append(WarrantyLength(length: 5, timeUnit: .years))
        
        view.addSubview(numberPicker)
    }
    
    // MARK: - ConfigureButtons
    private func configureButtons() {
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        okButton = UIButton(type: .custom)
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(.St_primaryColor, for: .normal)
        okButton.addTarget(self, action: #selector(setWarranty), for: .touchUpInside)
        
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
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        numberPicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            infoLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            infoLabel.leadingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.trailingAnchor),
            numberPicker.topAnchor.constraint(equalToSystemSpacingBelow: infoLabel.bottomAnchor, multiplier: 1),
            numberPicker.leadingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leadingAnchor),
            numberPicker.trailingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.trailingAnchor),
            numberPicker.bottomAnchor.constraint(lessThanOrEqualTo: buttonStack.topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func setWarranty() {
        let selectedWarrantyLength = numberPickerDataSource[numberPicker.selectedRow(inComponent: 0)]
        warrantyPickerDelegate?.setWarrantyLength(selectedWarrantyLength)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDelegateDataSource
extension WarrantyPickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberPickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = "\(numberPickerDataSource[row].length) \(numberPickerDataSource[row].timeUnit.rawValue)"
        return title
    }
}
