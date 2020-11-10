//
//  FilterSheetVC.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 09/11/2020.
//

import UIKit
import CoreData

class FilterSheetVC: UIViewController {
    
    private var coreDataStore: St_CoreDataStore! = nil
    private var expandButton: UIButton! = nil
    private var resetButton: UIButton! = nil
    
    private var groupsCollectionView: UICollectionView! = nil
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, NSManagedObjectID>! = nil
    private var fetchedResultsController: NSFetchedResultsController<St_Group>! = nil
    private var selectedGroupsStack: UIStackView! = nil
    var selectedGroups: [St_Group]! = nil
    
    init(coreDataStore: St_CoreDataStore) {
        super.init(nibName: nil, bundle: nil)
        self.coreDataStore = coreDataStore
        selectedGroups = [St_Group]()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureButtons()
        configureStackView()
        configureCollectionView()
        configureDataSource()
        configureFetchedResultsController()
        configureConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Configure
    private func configureView() {
        view.backgroundColor = .systemYellow
    }
    
    private func configureButtons() {
        expandButton = UIButton(type: .custom)
        expandButton.setImage(UIImage(systemName: "plus"), for: .normal)
        expandButton.backgroundColor = .St_primaryColor
        expandButton.tintColor = .white
        expandButton.addTarget(self, action: #selector(maximizeOrMinimizeView), for: .touchUpInside)
        
        resetButton = UIButton(type: .custom)
        resetButton.setImage(UIImage(systemName: "minus"), for: .normal)
        resetButton.backgroundColor = .St_primaryColor
        resetButton.tintColor = .white
        resetButton.addTarget(self, action: #selector(maximizeOrMinimizeView), for: .touchUpInside)
        
        view.addSubview(expandButton)
        view.addSubview(resetButton)
    }
    
    // MARK: - StackView
    private func configureStackView() {
        selectedGroupsStack = UIStackView()
        selectedGroupsStack.axis = .horizontal
        selectedGroupsStack.distribution = .fillEqually
        
        view.addSubview(selectedGroupsStack)
        
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
            guard let object = try? self.coreDataStore.persistentContainer.viewContext.existingObject(with: objectID) else {
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
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStore.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            print("Initial Fetch of St_Group is good!")
        } catch {
            print("Initial Fetch of St_Group failed")
        }
    }
    
    // MARK: - Constraints
    private func configureConstraints() {
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        selectedGroupsStack.translatesAutoresizingMaskIntoConstraints = false
        groupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            expandButton.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            expandButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            resetButton.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: resetButton.trailingAnchor, multiplier: 1),
            selectedGroupsStack.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            selectedGroupsStack.leadingAnchor.constraint(equalToSystemSpacingAfter: expandButton.trailingAnchor, multiplier: 1),
            resetButton.trailingAnchor.constraint(equalToSystemSpacingAfter: selectedGroupsStack.trailingAnchor, multiplier: 1),
            groupsCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: expandButton.bottomAnchor, multiplier: 2),
            groupsCollectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: groupsCollectionView.trailingAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalTo: groupsCollectionView.bottomAnchor, constant: 1)
        ])
    }
    
    // MARK: - Actions
    @objc private func maximizeOrMinimizeView() {
        print("mazimiiisimvidsdims")
    }
    
    private func updateStackView() {
        for group in selectedGroups! {
            var button: St_GroupButton = St_GroupButton(group: group)
            selectedGroupsStack.addArrangedSubview(button)
        }
    }
    
}

// MAKR: - UICollectionViewDelegate
extension FilterSheetVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let store = self.coreDataStore else {
            fatalError("The Core Data Store was nil.")
        }
        guard let object = diffableDataSource.itemIdentifier(for: indexPath) else {
            fatalError("Error when selecting group.")
        }
        guard let group = try? store.persistentContainer.viewContext.existingObject(with: object) else {
            fatalError("Managed object should be available")
        }
        let selectedGroup = group as! St_Group
        selectedGroups?.append(selectedGroup)
        updateStackView()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterSheetVC: UICollectionViewDelegateFlowLayout {
    
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
extension FilterSheetVC: NSFetchedResultsControllerDelegate {
    
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
