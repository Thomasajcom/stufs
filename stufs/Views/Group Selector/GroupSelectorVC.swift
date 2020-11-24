//
//  GroupSelectorVC.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 29/10/2020.
//

import UIKit
import CoreData

protocol GroupSelectorVCDelegate {
    func updateSelectedGroup(with group: St_Group)
}

class GroupSelectorVC: UIViewController {
    
    var groupSelectorVCDelegate: GroupSelectorVCDelegate?
    private var group: St_Group?
    private var coreDataStore: St_CoreDataStore! = nil
    private var context: NSManagedObjectContext! = nil
    
    private var cardView = UIView()
    private var titleLabel: UILabel! = nil
    private var infoLabel: UILabel! = nil
    private var nameLabel: UILabel! = nil
    private var nameTextField: UITextField! = nil
    private var buttonStack: UIStackView! = nil
    private var cancelButton: UIButton! = nil
    private var okButton: UIButton! = nil
    
    private var existingLabel: UILabel! = nil
    private var groupsCollectionView: UICollectionView! = nil
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, NSManagedObjectID>! = nil
    private var fetchedResultsController: NSFetchedResultsController<St_Group>! = nil
    
    init(coreDataStore: St_CoreDataStore, group: St_Group?, context: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)
        self.coreDataStore = coreDataStore
        self.group = group
        self.context = context
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLabels()
        configureTextField()
        configureCollectionView()
        configureDataSource()
        configureFetchedResultsController()
        configureButtons()
        configureConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fetchedResultsController.fetchedObjects!.count < 1 {
            existingLabel.isHidden = true
        } else {
            existingLabel.isHidden = false
        }
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
        
        existingLabel = UILabel()
        existingLabel.textColor = .secondaryLabel
        existingLabel.adjustsFontSizeToFitWidth = true
        existingLabel.minimumScaleFactor = 0.7
        existingLabel.font = .preferredFont(forTextStyle: .footnote)
        
        
        titleLabel.text = "Group"
        infoLabel.text = "Grouping items makes them easier to find. Try to be descriptive, e.g. \"Electronics\", \"Board Games\" or \"Clothes\"! "
        nameLabel.text = "Name:"
        existingLabel.text = "Select existing Group"


        view.addSubview(titleLabel)
        view.addSubview(infoLabel)
        view.addSubview(nameLabel)
        view.addSubview(existingLabel)
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
    
    // MARK: - CollectionView
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        groupsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        groupsCollectionView.delegate = self
        groupsCollectionView.backgroundColor = .systemBackground
        groupsCollectionView.register(St_GroupGroupSelectorCell.self, forCellWithReuseIdentifier: St_GroupGroupSelectorCell.reuseIdentifier)
        
        view.addSubview(groupsCollectionView)
    }
    
    // MARK: - ConfigureDataSource
    private func configureDataSource() {
        let diffableDataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID> (collectionView: self.groupsCollectionView) { (collectionView, indexPath, objectID) -> UICollectionViewCell? in
            //the object, an St_Group, to display in the collectionView
            guard let object = try? self.context?.existingObject(with: objectID) else {
                fatalError("Managed object should be available - it seems the save isnt done yet?")
            }
            let group = object as! St_Group
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: St_GroupGroupSelectorCell.reuseIdentifier, for: indexPath) as! St_GroupGroupSelectorCell
            cell.setupCell(with: group)
            return cell
        }
        
        self.diffableDataSource = diffableDataSource
        
        groupsCollectionView.dataSource = diffableDataSource
    }
    
    // MARK: - ConfigureFetchesResultsController
    private func configureFetchedResultsController() {
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let request: NSFetchRequest<St_Group> = St_Group.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            print("Initial Fetch of St_Group is good!")
        } catch {
            print("Initial Fetch of St_Group failed")
        }
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
        existingLabel.translatesAutoresizingMaskIntoConstraints = false
        groupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
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
            existingLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 2),
            existingLabel.leadingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leadingAnchor),
            groupsCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: existingLabel.bottomAnchor, multiplier: 1),
            groupsCollectionView.leadingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leadingAnchor),
            groupsCollectionView.trailingAnchor.constraint(equalTo: cardView.layoutMarginsGuide.trailingAnchor),
            groupsCollectionView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor),
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
        let newGroup = St_Group(context: context)
        if nameTextField.text?.isEmpty == false {
            newGroup.name = nameTextField.text!
            #warning("Select a random color from a predefined set of colors")
            newGroup.color = UIColor.systemGreen
            coreDataStore.persistentContainer.viewContext.perform({
                self.coreDataStore.saveContext(context: newGroup.managedObjectContext)
            })
        }
        groupSelectorVCDelegate?.updateSelectedGroup(with: newGroup)
        #warning("Alert user about Saved Group")
        dismiss(animated: true, completion: nil)
    }
    
}

// MAKR: - UICollectionViewDelegate
extension GroupSelectorVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let object = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }

        guard let contextSensitiveGroup = try? self.context?.existingObject(with: object) else {
            fatalError("Didn't find the group in the given context")
        }
        let selectedGroup = contextSensitiveGroup as! St_Group

        groupSelectorVCDelegate?.updateSelectedGroup(with: selectedGroup)
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GroupSelectorVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension GroupSelectorVC: NSFetchedResultsControllerDelegate {
    
    //thanks to https://www.avanderlee.com/swift/diffable-data-sources-core-data/
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        print("in the GroupSelectorVC: NSFetchedResultsControllerDelegate ")
        guard let dataSource = groupsCollectionView?.dataSource as? UICollectionViewDiffableDataSource<Int, NSManagedObjectID> else {
            assertionFailure("The data source has not implemented snapshot support while it should")
            return
        }
        var snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        let currentSnapshot = dataSource.snapshot() as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        
        let reloadIdentifiers: [NSManagedObjectID] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
            guard let currentIndex = currentSnapshot.indexOfItem(itemIdentifier), let index = snapshot.indexOfItem(itemIdentifier), index == currentIndex else {
                return nil
            }
            guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier), existingObject.isUpdated else { return nil }
            return itemIdentifier
        }
        snapshot.reloadItems(reloadIdentifiers)
        
        let shouldAnimate = groupsCollectionView?.numberOfSections != 0
        print("applying new snapshot")
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>, animatingDifferences: shouldAnimate)
        
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
