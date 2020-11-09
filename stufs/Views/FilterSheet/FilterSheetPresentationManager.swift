//
//  FilterSheetPresentationManager.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 09/11/2020.
//

import UIKit

enum PresentationDirection {
    case up
    case left
    case down
}

class FilterSheetPresentationManager: NSObject {
    
    var direction: PresentationDirection = .up

}

extension FilterSheetPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = FilterSheetPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
        return presentationController
    }
}
