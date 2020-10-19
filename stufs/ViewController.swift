//
//  ViewController.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 13/10/2020.
//

import UIKit

class ViewController: UIViewController {
    
    private var tabs: UISegmentedControl! = nil
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNav()
        configureView()
        configureTabs()
        configureSearchBar()
        configureCollectionView()
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
        let tabTitles = ["Star", "Wish List", "Owned", "Trash"]
        
        for status in St_ItemStatus.allCases {
            print("status er: \(status)")
            print("bilde er: \(status.image)")
        }
        tabs = UISegmentedControl(items: tabTitles)
        view.addSubview(tabs)
    }
    
    private func configureSearchBar() {
        
    }
    
    private func configureCollectionView() {
        
    }
    
    private func configureAddItemButton() {
        
    }
    
    private func configureGroupTray() {
        
    }
    
    private func configureConstraints() {
        tabs.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        tabs.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                        tabs.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                        tabs.topAnchor.constraint(equalTo: view.topAnchor),
                                    tabs.heightAnchor.constraint(equalToConstant: 150)])
        
    }
    
    // MARK: - Actions
    @objc private func goToSettings() {
        
    }
    
}

enum St_ItemStatus: CaseIterable {
    case favorite
    case wishlist
    case owned
    case discarded
    
    //name property
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
    
}
