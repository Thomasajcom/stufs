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
    
    private var selectedGroupsCollectionView: UICollectionView! = nil
    private var selectedGroupsDataSource: UICollectionViewDiffableDataSource<Section, St_Group>! = nil
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
        configureSelectedCollectionView()
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
    
    // MARK: ConfigureButtons
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
        //        view.addSubview(resetButton)
    }
    
    // MARK: CollectionView
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        groupsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        groupsCollectionView.delegate = self
        groupsCollectionView.backgroundColor = .systemBackground
        groupsCollectionView.register(St_GroupGroupSelectorCell.self, forCellWithReuseIdentifier: St_GroupGroupSelectorCell.reuseIdentifier)
        
        view.addSubview(groupsCollectionView)
    }
    
    // MARK: ConfigureDataSource
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
    
    // MARK: ConfigureFetchesResultsController
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
        //        resetButton.translatesAutoresizingMaskIntoConstraints = false
        groupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectedGroupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            expandButton.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            expandButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            //            resetButton.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            //            view.trailingAnchor.constraint(equalToSystemSpacingAfter: resetButton.trailingAnchor, multiplier: 1),
            selectedGroupsCollectionView.heightAnchor.constraint(equalToConstant: 75),
            selectedGroupsCollectionView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            selectedGroupsCollectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: expandButton.trailingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: selectedGroupsCollectionView.trailingAnchor, multiplier: 1),
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
        let cell = collectionView.cellForItem(at: indexPath) as? St_GroupGroupSelectorCell

        if let groupIndex = selectedGroups.firstIndex(of: selectedGroup) {
            selectedGroups?.remove(at: groupIndex)
            cell?.removeShadow()
        } else {
            selectedGroups?.append(selectedGroup)
            cell?.addShadow()
        }
        applySelectedGroupsSnapshot()
        
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

// MARK: - SELECTED GROUP COLLECTION VIEW
extension FilterSheetVC {
    private enum Section {
        case main
    }
    // MARK: SelectedCollectionView
    private func configureSelectedCollectionView() {
        selectedGroupsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createSelectedLayout())
        selectedGroupsCollectionView.isUserInteractionEnabled = false
        selectedGroupsCollectionView.delegate         = self
        selectedGroupsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        selectedGroupsCollectionView.backgroundColor  = .green
        view.addSubview(selectedGroupsCollectionView)
        
        selectedGroupsCollectionView.register(St_GroupGroupSelectorCell.self, forCellWithReuseIdentifier: St_GroupGroupSelectorCell.reuseIdentifier)
        selectedGroupsDataSource = UICollectionViewDiffableDataSource(collectionView: selectedGroupsCollectionView, cellProvider: { (selectedGroupsCollectionView, indexPath, group) -> St_GroupGroupSelectorCell? in
            guard let cell = selectedGroupsCollectionView.dequeueReusableCell(withReuseIdentifier: St_GroupGroupSelectorCell.reuseIdentifier, for: indexPath) as? St_GroupGroupSelectorCell else {
                fatalError("unable to dequeue cell")
            }
            cell.setupCell(with: group)
            return cell
        })
    }
    
    // MARK: Apply Snapshot
    private func applySelectedGroupsSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, St_Group>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.selectedGroups)
        selectedGroupsDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - LAYOUT
    private func createSelectedLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
