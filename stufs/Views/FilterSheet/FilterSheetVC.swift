//
//  FilterSheetVC.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 09/11/2020.
//

import UIKit

class FilterSheetVC: UIViewController {
    
    private var expandButton: UIButton! = nil
    private var resetButton: UIButton! = nil
    
    private var groupsCollectionView: UICollectionView! = nil

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureButtons()
        configureStackView()
        configureCollectionView()
        configureConstraints()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Configure
    private func configureView() {
        view.backgroundColor = .systemRed
        print("🔈🔈🔈🔈🔈🔈🔈")
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
    
    // MARK: - Constraints
    private func configureConstraints() {
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        groupsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandButton.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            expandButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            resetButton.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: resetButton.trailingAnchor, multiplier: 1),
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
        //selected an item in the collection
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FilterSheetVC: UICollectionViewDelegateFlowLayout {
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
