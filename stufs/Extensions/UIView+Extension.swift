//
//  UIView+Extension.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 09/11/2020.
//

import Foundation
import UIKit

extension UIView {
    /// Rounds the given corners in a given radius
    /// - Parameters:
    ///   - corners: The corners to round off
    ///   - radius: The amount the corners should be rounded
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /// Pins a view to its parent view's edges
    /// - Parameter view: The view to pin to
        func pin(to view: UIView) {
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: view.topAnchor),
                leadingAnchor.constraint(equalTo: view.leadingAnchor),
                trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
}
