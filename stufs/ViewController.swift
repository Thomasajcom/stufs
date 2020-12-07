//
//  ViewController.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 13/10/2020.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private static let filterSheetOffset: CGFloat = 70
    
    private var coreDataStore: St_CoreDataStore! = nil
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, NSManagedObjectID>! = nil
    private var fetchedResultsController: NSFetchedResultsController<St_Item>! = nil
    
    private var tabs: UISegmentedControl! = nil
    private var collectionView: UICollectionView! = nil
    
    private var addItemButton: St_Button! = nil
    
    private var filterSheetButton: UIButton! = nil
    private var filterSheet: FilterSheetVC! =  nil
    lazy var filterSheetTransitioningDelegate = FilterSheetPresentationManager()
    
    
    init(coreDataStore: St_CoreDataStore) {
        self.coreDataStore = coreDataStore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNav()
        configureView()
        configureTabs()
        configureSearchBar()
        configureCollectionView()
        configureDataSource()
        configureFetchedResultsController()
        configureButtons()
        configureFilterSheet()
        configureConstraints()
        view.layoutIfNeeded()
    }
    
    // MARK: - Configuration
    private func configureNav() {
        title = "stØfs"
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(goToSettings))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func configureView() {
        view.backgroundColor = .systemPurple
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
        
        // customizing the segmented control
        
        //        https://stackoverflow.com/questions/42755590/how-to-display-only-bottom-border-for-selected-item-in-uisegmentedcontrol/42755823
        //        let greenImage = UIColor.green.getAsImage(CGSize(width: 10, height: tabs.bounds.size.height))
        //        let whiteImage = UIColor.white.getAsImage(CGSize(width: 1, height: (self.navigationController?.navigationBar.frame.height)!))
        //        tabs.setBackgroundImage(greenImage, for: .normal, barMetrics: .default)
        //        tabs.setBackgroundImage(whiteImage, for: .selected, barMetrics: .default)
        
        //        func removeBorder(){
        //              let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        //              self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        //              self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        //              self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)
        //
        //              let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        //              self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        //              self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray], for: .normal)
        //              self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
        //          }
        
        #warning("This should be a user setting")
        tabs.selectedSegmentIndex = 2
        
        
        view.addSubview(tabs)
    }
    
    private func configureSearchBar() {
        
    }
    
    // MARK: configureCollectionView
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(St_ItemCell.self, forCellWithReuseIdentifier: St_ItemCell.reuseIdentifier)
        collectionView.backgroundColor = .selectedTabColor
        
        view.addSubview(collectionView)
    }
    
    // MARK: configureDataSource
    private func configureDataSource() {
        let diffableDataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID> (collectionView: self.collectionView) { (collectionView, indexPath, objectID) -> UICollectionViewCell? in
            //the object, an St_Item, to display in the collectionview
            guard let object = try? self.coreDataStore.persistentContainer.viewContext.existingObject(with: objectID) else {
                fatalError("Managed object should be available, but wasn't saved!")
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: St_ItemCell.reuseIdentifier, for: indexPath) as! St_ItemCell
            cell.configureCell(for: object as! St_Item)
            /// ... Setup cell with the managed object
            return cell
        }
        
        self.diffableDataSource = diffableDataSource
        
        collectionView.dataSource = diffableDataSource
    }
    
    // MARK: FetchedResultsConstroller
    private func configureFetchedResultsController() {
        let sortDescriptor = NSSortDescriptor(key: "warrantyLength", ascending: true)
        let request: NSFetchRequest<St_Item> = St_Item.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStore.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        
        do {
            try fetchedResultsController.performFetch()
            print("Initial Fetch is good!")
        } catch {
            print("Initial Fetch failed")
        }
    }
    
    // MARK: ConfigureButton
    private func configureButtons() {
        addItemButton = St_Button()
        addItemButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addItemButton.addTarget(self, action: #selector(goToAddItem(sender:)), for: .touchUpInside)
        
        filterSheetButton = UIButton(type: .custom)
        filterSheetButton.setImage(UIImage(systemName: "minus"), for: .normal)
        filterSheetButton.addTarget(self, action: #selector(showFilter), for: .touchUpInside)
        
        view.addSubview(addItemButton)
        //        view.addSubview(filterSheetButton)
    }
    
    // MARK: FILTERSHEET
    private func configureFilterSheet() {
        filterSheet = FilterSheetVC(coreDataStore: coreDataStore)
        self.add(filterSheet, frame: nil)
        filterSheet.view.translatesAutoresizingMaskIntoConstraints = false

        
        let filterSheetTopAnchor: NSLayoutConstraint = filterSheet.view.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.filterSheetOffset)
        let filterSheetBottomAnchor: NSLayoutConstraint = filterSheet.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        filterSheet.view.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1).isActive = true
        view.trailingAnchor.constraint(equalToSystemSpacingAfter: filterSheet.view.trailingAnchor, multiplier: 1).isActive = true
        filterSheet.view.heightAnchor.constraint(equalToConstant: self.view.frame.height/3).isActive = true
        filterSheetTopAnchor.isActive = true
        
        //when we toggle the visibility of the sheet we slide it up from its nested position at the bottom of the screen (-25 from absolute bottom)
        filterSheet.toggleFilterSheetVisibility = {
            filterSheetTopAnchor.isActive.toggle()
            filterSheetBottomAnchor.isActive.toggle()
            UIView.animate(withDuration: 0.5,
                           delay: 0, usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 1.0,
                           options: .curveEaseInOut, animations: {
                            self.view.layoutIfNeeded()
                            self.filterSheet.expandButton.transform = self.filterSheet.viewIsExpanded ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat.pi)
                            self.filterSheet.resetButton.transform = self.filterSheet.viewIsExpanded ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat.pi)
                           }) { (_) in
                self.filterSheet.viewIsExpanded.toggle()
            }
        }
    }
    
    // MARK: - CONSTRAINTS
    private func configureConstraints() {
        tabs.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabs.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            tabs.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tabs.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tabs.heightAnchor.constraint(equalToConstant: 40),
            collectionView.topAnchor.constraint(equalTo: tabs.bottomAnchor, constant: -5),
            collectionView.leadingAnchor.constraint(equalTo: tabs.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: tabs.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addItemButton.centerXAnchor.constraint(equalTo: view.trailingAnchor),
            addItemButton.bottomAnchor.constraint(equalTo: filterSheet.view.topAnchor, constant: -10),
        ])
    }
    
    // MARK: - Actions
    @objc private func tabChanged(sender: UISegmentedControl) {
        //get the name of the selected tab, aka status
        let selectedTab = St_ItemStatus.allCases[sender.selectedSegmentIndex]
        //update the current snapshot to only show items with status == selectedTab.name
        
    }
    
    @objc private func goToAddItem(sender: UIButton) {
        let addItemVC = AddItemVC(coreDataStore: self.coreDataStore)
        let nav = UINavigationController(rootViewController: addItemVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func showFilter(sender: UIButton) {
        let filterSheet = AddItemVC(coreDataStore: self.coreDataStore)
        filterSheetTransitioningDelegate.direction = .up
        filterSheet.transitioningDelegate = filterSheetTransitioningDelegate
        filterSheet.modalPresentationStyle = .custom
        present(filterSheet, animated: true)
    }
    
    @objc private func goToSettings() {
        
    }
    
    
    
    // MARK: Layout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = .init(top: 5, leading: 5, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(10)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: 10, bottom: 5, trailing: 10)
        section.interGroupSpacing = 10
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: layoutConfig)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}



extension ViewController: NSFetchedResultsControllerDelegate {
    
    //thanks to https://www.avanderlee.com/swift/diffable-data-sources-core-data/
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        print("IN ThE DELETAGET DIDCHANGECONTENTWITH")
        guard let dataSource = collectionView?.dataSource as? UICollectionViewDiffableDataSource<Int, NSManagedObjectID> else {
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
        
        let shouldAnimate = collectionView?.numberOfSections != 0
        print("applying new snapshot")
        dataSource.apply(snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>, animatingDifferences: shouldAnimate)
        
    }
    
}
