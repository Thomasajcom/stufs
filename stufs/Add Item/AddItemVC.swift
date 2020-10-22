//
//  AddItemVC.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 22/10/2020.
//

import UIKit
import CoreData

class AddItemVC: UIViewController {
    
    private var container: NSPersistentCloudKitContainer! = nil
    
    private var tabs: UISegmentedControl! = nil
    private var tableView: UITableView! = nil
    private var itemInfoCells: [St_AddItemTextFieldCellData]! = nil
    private var acquiredInfoCell: St_AddItemTextFieldCellData! = nil
    
    private var nameTextField:UITextField! = nil
    

    
    init(container: NSPersistentCloudKitContainer) {
        super.init(nibName: nil, bundle: nil)
        self.container = container
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTabs()
        configureTableView()
        configureDataSource()
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
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(St_AddItemTextInputCell.self, forCellReuseIdentifier: St_AddItemTextInputCell.reuseIdentifier)
        tableView.register(St_AddItemImageCell.self, forCellReuseIdentifier: St_AddItemImageCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .selectedTabColor
        tableView.rowHeight = 50

        
        
        
        view.addSubview(tableView)
    }
    
    private func configureDataSource() {
        itemInfoCells = [
            St_AddItemTextFieldCellData(title: "Name:", placeholder: "Name the item"),
            St_AddItemTextFieldCellData(title: "fdas:", placeholder: "Wdsafdasfsda")
        ]
        
        acquiredInfoCell = St_AddItemTextFieldCellData(title: "From:", placeholder: "Where did you acquire the item")
    }
    
    // MARK: - Actions
    
    @objc private func setAsFavorite(sender: UIBarButtonItem) {
        
    }
    
    @objc private func tabChanged(sender: UISegmentedControl) {

    }
    
    // MARK: - Constraints
    private func configureConstraints() {
        tabs.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabs.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            tabs.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tabs.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tabs.heightAnchor.constraint(equalToConstant: 40),
            tableView.topAnchor.constraint(equalTo: tabs.bottomAnchor, constant: -5),
            tableView.leadingAnchor.constraint(equalTo: tabs.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tabs.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
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
            return 5
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.section {
        // Info Section
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemTextInputCell.reuseIdentifier) as! St_AddItemTextInputCell
                cell.setUpCell(with: itemInfoCells[indexPath.row])
                return cell
            }
            
        // Photo Section
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemImageCell.reuseIdentifier) as! St_AddItemImageCell
            return cell
        // Acquired Section
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemTextInputCell.reuseIdentifier) as! St_AddItemTextInputCell
                cell.setUpCell(with: acquiredInfoCell)
                return cell
            }else {
                let cell = UITableViewCell()
                return cell
            }
            
        default:
            let cell = UITableViewCell()
            return cell
        }
        
        let cell = UITableViewCell()
        return cell
        
    }
    
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
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = St_ItemStatus.owned.infoText
        label.backgroundColor = .red
        switch section {

        case St_AddItemSectionHeaders.photos.rawValue:
            return "Photo"
        case St_AddItemSectionHeaders.acquired.rawValue:
            return "Acquired"
        default:
            return nil
        }

    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case St_AddItemSectionHeaders.allCases.count:
            let saveButton = UIButton(type: .custom)
            saveButton.setImage(UIImage(systemName: "star"), for: .normal)
            saveButton.setTitle("SAVE ITEM", for: .normal)
            return saveButton
        default:
            return nil
        }
        
    }
    
    
}


struct St_AddItemTextFieldCellData {
    let title: String?
    let placeholder: String?
}

enum St_AddItemSectionHeaders: Int, CaseIterable {
    case info = 0, photos, acquired
}


