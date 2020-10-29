//
//  AddItemVC.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 22/10/2020.
//

import UIKit
import CoreData

class AddItemVC: UIViewController {
    
    private var coreDataStore: St_CoreDataStore! = nil
    private var newItem: St_Item! = nil
    
    private var tabs: UISegmentedControl! = nil
    private var tableView: UITableView! = nil
    private var itemInfoCells: [St_AddItemCellData]! = nil
    private var acquiredInfoCell: St_AddItemTextFieldCellData! = nil
    
    private var nameTextField:UITextField! = nil

    
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
        tableView.allowsSelection = false
        tableView.register(St_AddItemTextInputCell.self, forCellReuseIdentifier: St_AddItemTextInputCell.reuseIdentifier)
        tableView.register(St_AddItemImageCell.self, forCellReuseIdentifier: St_AddItemImageCell.reuseIdentifier)
        tableView.register(St_AddItemGroupSelectorCell.self, forCellReuseIdentifier: St_AddItemGroupSelectorCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .selectedTabColor
        tableView.rowHeight = 50
        
        view.addSubview(tableView)
    }
    
    private func configureDataSource() {
        itemInfoCells = [
            St_AddItemTextFieldCellData(title: "Name:", placeholder: "Name the item"),
            St_AddItemTextFieldCellData(title: "Wdsafdasfsda", placeholder: "fdas:"),
            St_AddItemImageCellData(title: "Item")
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
    
    // MARK: - CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.section {
        // Info Section
        case 0:
            if indexPath.row == 0 {
                // Item NAME
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemTextInputCell.reuseIdentifier) as! St_AddItemTextInputCell
                cell.setUpCell(with: itemInfoCells[indexPath.row])
                return cell
            } else if indexPath.row == 1 {
                // Item GROUP
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemGroupSelectorCell.reuseIdentifier) as! St_AddItemGroupSelectorCell
                cell.groupDelegate = self
                return cell
            } else if indexPath.row == 2 {
                // Item WARRANTY LENGTH

            } else if indexPath.row == 3 {
                // Item NOTES

            }
            
        // Photo Section
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemImageCell.reuseIdentifier) as! St_AddItemImageCell
            return cell
        // Acquired Section
        case 2:
            if indexPath.row == 0 {
                // Item ACQUIRED WHERE
                let cell = tableView.dequeueReusableCell(withIdentifier: St_AddItemTextInputCell.reuseIdentifier) as! St_AddItemTextInputCell
                cell.setUpCell(with: acquiredInfoCell)
                return cell
            }else {
                // Item ACQUIRED WHEN
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
    
    // MARK: - Footer
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

extension AddItemVC: St_AddItemGroupSelectorCellDelegate {
    func goToGroupSelection(group: St_Group?) {
        let groupSelector = GroupSelectorVC(coreDataStore: self.coreDataStore, group: group)
        groupSelector.groupSelectorVCDelegate = self
        groupSelector.isModalInPresentation = true
        present(groupSelector, animated: true)
    }
}


// MARK: - GroupSelectorVCDelegate
extension AddItemVC: GroupSelectorVCDelegate {
    func updateSelectedGroup(with group: St_Group) {
        self.newItem.group = group
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? St_AddItemGroupSelectorCell
        cell?.set(group: group)
    }
}


protocol St_AddItemCellData {
    var title: String {get}
    var placeholder: String? {get}

}

struct St_AddItemTextFieldCellData: St_AddItemCellData {
    var title: String
    var placeholder: String?
}

struct St_AddItemImageCellData: St_AddItemCellData {
    var title: String
    var placeholder: String?
}

enum St_AddItemSectionHeaders: Int, CaseIterable {
    case info = 0, photos, acquired
}


