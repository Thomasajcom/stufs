//
//  FilterSheetPresentationController.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 09/11/2020.
//

import UIKit

class FilterSheetPresentationController: UIPresentationController {
    private var direction: PresentationDirection
    private var dimmingView: UIView!
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
          frame.size = size(forChildContentContainer: presentedViewController,
                            withParentContainerSize: containerView!.bounds.size)

          
          switch direction {
          case .up:
            frame.origin.y = containerView!.frame.height-(containerView!.frame.height/3)
          case .left:
            frame.origin.y = containerView!.frame.height*(1.0/3.0)
          default:
            frame.origin = .zero
          }
          return frame
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
        self.direction = direction
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else {
            return
        }
        
        containerView!.insertSubview(dimmingView, at: 0)
        dimmingView.pin(to: containerView!)
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .up:
            return CGSize(width: parentSize.width, height: 200)
        case .left:
            return CGSize(width: 200, height: 200)

        case .down:
            return CGSize(width: parentSize.width, height: 20)

        }
        
    }
    
    
}

private extension FilterSheetPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
}
