//
//  St_Group+CoreDataProperties.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 13/10/2020.
//
//

import Foundation
import CoreData
import UIKit


extension St_Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<St_Group> {
        return NSFetchRequest<St_Group>(entityName: "St_Group")
    }

    @NSManaged public var name: String
    @NSManaged public var color: UIColor
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension St_Group {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: St_Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: St_Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension St_Group : Identifiable {

}
