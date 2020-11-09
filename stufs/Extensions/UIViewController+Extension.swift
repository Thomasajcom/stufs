//
//  File.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 09/11/2020.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// Adds a VC to the given view controller
    /// - Parameters:
    ///   - child: The child VC to add
    ///   - frame: the frame of the child, if using frames
    func add(_ child: UIViewController, frame: CGRect? = nil) {
            addChild(child)

            if let frame = frame {
                child.view.frame = frame
            }

            view.addSubview(child.view)
            child.didMove(toParent: self)
        }
}
