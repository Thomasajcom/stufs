//
//  ColorValueTransformer.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 29/10/2020.
//  Since we're storing UIColor in core data, we need to conform to NSSecureCoding
//  Read more: https://www.kairadiagne.com/2020/01/13/nssecurecoding-and-transformable-properties-in-core-data.html

import UIKit

@objc(UIColorValuteTransformer)
final class ColorValueTransformer: NSSecureUnarchiveFromDataTransformer {
    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: ColorValueTransformer.self))
    
    // 2. Make sure `UIColor` is in the allowed class list.
    override static var allowedTopLevelClasses: [AnyClass] {
        return [UIColor.self]
    }
    
    /// Registers the transformer.
    public static func register() {
        let transformer = ColorValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
