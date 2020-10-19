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
        
    }
    
    private func configureAddItemButton() {
        
    }
    
    private func configureGroupTray() {
        
    }
    
    private func configureConstraints() {
        tabs.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabs.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            tabs.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tabs.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
    }
    
    // MARK: - Actions
    @objc private func tabChanged(sender: UISegmentedControl) {
        
    }
    
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
