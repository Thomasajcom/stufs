//
//  AddItemVC.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 22/10/2020.
//

import UIKit
import CoreData

enum St_AddItemSectionHeaders: Int, CaseIterable {
    case info = 0, photos, acquired
}

class AddItemVC: UIViewController {
    
    var coreDataStore: St_CoreDataStore! = nil
    var newItem: St_Item! = nil
    
    private var tabs: UISegmentedControl! = nil
    var tableView: UITableView! = nil
    var selectedImage: St_AddItemImage?
    private var okButton: UIButton! = nil
    private var cancelButton: UIButton! = nil
    private var buttonStack: UIStackView! = nil
    
    init(coreDataStore: St_CoreDataStore) {
        super.init(nibName: nil, bundle: nil)
        self.coreDataStore = coreDataStore
        self.newItem = St_Item(context: self.coreDataStore.persistentContainer.viewContext)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTabs()
        configureTableView()
        configureSaveButton()
        configureConstraints()
    }
    
    // MARK: - Configure
    private func configureView() {
        view.backgroundColor = .systemPurple
        navigationController?.navigationBar.backgroundColor = .St_primaryColor
        title = "New Item"
        navigationController?.navigationBar.prefersLargeTitles = true
//        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(setAsFavorite))
//        navigationController?.navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func configureTabs() {
        tabs = UISegmentedControl(items: St_ItemStatus.allCases.map({ $0.image ?? $0.name as Any  }) )
        tabs.addTarget(self, action: #selector(tabChanged), for: .valueChanged)
        //appearance
        tabs.backgroundColor = .nonselectedTabColor
        tabs.selectedSegmentTintColor = .selectedTabColor
        tabs.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        tabs.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .selected)
        tabs.apportionsSegmentWidthsByContent = true

        tabs.selectedSegmentIndex = 2
        
        view.addSubview(tabs)
    }
    
    // MARK: - ConfigureTableView
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.allowsSelection = false
        tableView.register(St_AddItemTextInputCell.self, forCellReuseIdentifier: St_AddItemTextInputCell.reuseIdentifier)
        tableView.register(St_AddItemImageCell.self, forCellReuseIdentifier: St_AddItemImageCell.reuseIdentifier)
        tableView.register(St_AddItemGroupSelectorCell.self, forCellReuseIdentifier: St_AddItemGroupSelectorCell.reuseIdentifier)
        tableView.register(St_AddItemWarrantyCell.self, forCellReuseIdentifier: St_AddItemWarrantyCell.reuseIdentifier)
        tableView.register(St_AddItemAcquiredDateCell.self, forCellReuseIdentifier: St_AddItemAcquiredDateCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .selectedTabColor
        
        view.addSubview(tableView)
    }
    
    // MARK: - ConfigureSaveButton
    private func configureSaveButton() {
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        okButton = UIButton(type: .custom)
        okButton.setTitle("Create Group", for: .normal)
        okButton.setTitleColor(.secondaryLabel, for: .normal)
        okButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        
        buttonStack = UIStackView(arrangedSubviews: [cancelButton, okButton])
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
    }
    
    // MARK: - Actions
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveItem() {
        print("newItem er: \(String(describing: self.newItem))")
        let index = IndexPath(row: 0, section: 0)
            let cell: St_AddItemTextInputCell = self.tableView.cellForRow(at: index) as! St_AddItemTextInputCell
        print(cell.textField.text!)
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! St_AddItemTextInputCell
        if let newName = nameCell.textField.text {
            if newName.count > 0 {
                self.newItem.name = newName

            } else {
                #warning("Alert user to add a name")
                return
            }
        } else {
            return
        }
        
        let acquiredFromCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? St_AddItemTextInputCell
        if let newName = acquiredFromCell?.textField.text {
            if newName.count > 0 {
                self.newItem.name = newName
            }
        }
        let acquiredDateCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as? St_AddItemAcquiredDateCell
        self.newItem.acquiredDate = acquiredDateCell?.datePicker.date

        /*
acquiredDate = nil;
acquiredFrom = nil;
         discardedDate = nil;
         favorite = nil;
group = "0x8bf400189fa87ece <x-coredata://86A980BB-112B-42B1-B8C5-1D392A0FA110/St_Group/p1>";
itemPhoto = nil;
name = nil;
            notes = nil;
receiptPhoto = nil;
         status = nil;
         */
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func tabChanged(sender: UISegmentedControl) {

    }
    
    // MARK: - Constraints
    private func configureConstraints() {
        tabs.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabs.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            tabs.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tabs.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tabs.heightAnchor.constraint(equalToConstant: 40),
            tableView.topAnchor.constraint(equalTo: tabs.bottomAnchor, constant: -5),
            tableView.leadingAnchor.constraint(equalTo: tabs.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tabs.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

// MARK: UITableviewDelegateDataSource
extension AddItemVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return St_AddItemSectionHeaders.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        // Info Section
        case 0:
            return 3
        // Photo Section
        case 1:
            return 1
        // Acquired Section
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    // MARK: - CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.section {
        // Info Section
        case 0:
            if indexPath.row == 0 {
                // Item NAME
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemTextInputCell.reuseIdentifier) as! St_AddItemTextInputCell
                cell.addItemTextInputDelegate = self
                cell.setUpCell(title: .itemName, placeholder: "Name the item")
                return cell
            } else if indexPath.row == 1 {
                // Item GROUP
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemGroupSelectorCell.reuseIdentifier) as! St_AddItemGroupSelectorCell
                cell.groupDelegate = self
                return cell
            } else if indexPath.row == 2 {
                // Item WARRANTY LENGTH
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemWarrantyCell.reuseIdentifier) as! St_AddItemWarrantyCell
                cell.warrantyDelegate = self
                cell.setUpCell(title: "Warranty:", placeholder: "How long is the warranty?")
                return cell
            }
        // Photo Section
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemImageCell.reuseIdentifier) as! St_AddItemImageCell
            cell.addItemImageDelegate = self
            return cell
        // Acquired Section
        case 2:
            if indexPath.row == 0 {
                // Item ACQUIRED WHERE
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemTextInputCell.reuseIdentifier) as! St_AddItemTextInputCell
                cell.setUpCell(title: .acquiredFrom, placeholder: "Where was the item acquired?")
                return cell
            }else {
                // Item ACQUIRED WHEN
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemAcquiredDateCell.reuseIdentifier) as! St_AddItemAcquiredDateCell
                cell.setUpCell(title: "When:", placeholder: "When was the item acquired?")
                return cell
            }
        default:
            let cell = UITableViewCell()
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }
    
    // MARK: - Headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = St_ItemStatus.owned.infoText
        label.numberOfLines = 0
        
        switch section {
        case St_AddItemSectionHeaders.info.rawValue:
            return label
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case St_AddItemSectionHeaders.photos.rawValue:
            return "Photo"
        case St_AddItemSectionHeaders.acquired.rawValue:
            return "Acquired"
        default:
            return nil
        }

    }
}
