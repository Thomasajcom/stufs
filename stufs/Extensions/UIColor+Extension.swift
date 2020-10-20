//
//  UIColor+Extension.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 19/10/2020.
//

import Foundation
import UIKit


extension UIColor {
    static let selectedTabColor = UIColor(named: "selectedTabColor")
    static let nonselectedTabColor = UIColor(named: "nonselectedTabColor")
    static let St_ItemCellBackgroundColor = UIColor(named: "St_ItemCell_background")
    
    func getAsImage(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
