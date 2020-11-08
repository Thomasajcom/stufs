//
//  St_Item+CoreDataProperties.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 13/10/2020.
//
//

import Foundation
import CoreData


extension St_Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<St_Item> {
        return NSFetchRequest<St_Item>(entityName: "St_Item")
    }

    @NSManaged public var name: String
    @NSManaged public var status: String
    @NSManaged public var notes: String?
    @NSManaged public var itemPhoto: Data?
    @NSManaged public var receiptPhoto: Data?
    @NSManaged public var daysOfWarrantyRemaining: Int64
    @NSManaged public var acquiredFrom: String?
    @NSManaged public var acquiredDate: Date?
    @NSManaged public var discardedDate: Date?
    @NSManaged public var favorite: Bool
    @NSManaged public var group: St_Group?

}

extension St_Item : Identifiable {

}
