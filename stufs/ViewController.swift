//
//  ViewController.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 13/10/2020.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private var container: NSPersistentCloudKitContainer! = nil
    private var diffableDataSource: UICollectionViewDiffableDataSource<Int, NSManagedObjectID>! = nil
    private var fetchedResultsController: NSFetchedResultsController<St_Item>! = nil
    
    private var tabs: UISegmentedControl! = nil
    private var collectionView: UICollectionView! = nil
    
    private var fakeSource: [St_Item]! = nil
    
    init(container: NSPersistentCloudKitContainer) {
        self.container = container
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
        configureAddItemButton()
        configureGroupTray()
        configureConstraints()
    }
    
    // MARK: - Configuration
    private func configureNav() {
        title = "stØfs"
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(goToSettings))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func configureView() {
        view.backgroundColor = .purple
    }
    
    private func configureTabs() {
        tabs = UISegmentedControl(items: St_ItemStatus.allCases.map({ $0.image ?? "\($0)" as Any  }) )
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
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.register(St_ItemCell.self, forCellWithReuseIdentifier: St_ItemCell.reuseIdentifier)
        collectionView.backgroundColor = .selectedTabColor
        
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let diffableDataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID> (collectionView: self.collectionView) { (collectionView, indexPath, objectID) -> UICollectionViewCell? in
            //the object, an St_Item, to display in the collectionview
            guard let object = try? self.container.viewContext.existingObject(with: objectID) else {
                fatalError("Managed object should be available")
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: St_ItemCell.reuseIdentifier, for: indexPath) as! St_ItemCell
            cell.configureCell(for: object as! St_Item)
            /// ... Setup cell with the managed object
            return cell
        }
        
        self.diffableDataSource = diffableDataSource
        
        collectionView.dataSource = diffableDataSource
    }
    
    private func configureFetchedResultsController() {
        let sortDescriptor = NSSortDescriptor(key: "warrantyLength", ascending: true)
        let request: NSFetchRequest<St_Item> = St_Item.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            print("Initial Fetch is good!")
        } catch {
            print("Initial Fetch failed")
        }
    }
    
    private func configureAddItemButton() {
        
    }
    
    private func configureGroupTray() {
        
    }
    
    // MARK: - CONSTRAINTS
    private func configureConstraints() {
        tabs.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabs.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            tabs.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tabs.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tabs.heightAnchor.constraint(equalToConstant: 40),
            collectionView.topAnchor.constraint(equalTo: tabs.bottomAnchor, constant: -5),
            collectionView.leadingAnchor.constraint(equalTo: tabs.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: tabs.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    // MARK: - Actions
    @objc private func tabChanged(sender: UISegmentedControl) {
        print("creating a new item!")
        let item = St_Item(context: container.viewContext)
        item.name = "Test name"
        item.acquiredDate = Date()
        item.acquiredFrom = "Test acq from"
        item.discardedDate = nil
        item.favorite = false
        item.warrantyLength = 365
        item.status = St_ItemStatus.owned.name
        item.group = nil
        do {
            try container.viewContext.save()
        } catch  {
            print("something went wrong when saving")
        }
        
    }
    
    @objc private func goToSettings() {
        
    }
    
    
    
    // MARK: Layout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: layoutConfig)
        return layout
    }
    
}

enum St_ItemStatus: CaseIterable {
    
    case favorite
    case wishlist
    case owned
    case discarded
    
    var name: String {
        switch self {
        case .favorite:
            return "Favorite"
        case .wishlist:
            return "Wish List"
        case .owned:
            return "Owned"
        case .discarded:
            return "Discarded"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .favorite:
            return UIImage(systemName: "star")!
        case .discarded:
            return UIImage(systemName: "trash")!
        default:
            return nil
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .favorite:
            return UIImage(systemName: "star.fill")!
        case .discarded:
            return UIImage(systemName: "trash.fill")!
        default:
            return nil
        }
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
