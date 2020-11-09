//
//  St_Item+CoreDataClass.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 13/10/2020.
//
//

import Foundation
import CoreData

@objc(St_Item)
public class St_Item: NSManagedObject {
    
    
    /// Toggles the favorite property of an item
    func toggleFavoriteStatus() {
        self.favorite.toggle()
    }
    
    /// Checks if the item is ready to be saved to the core data store
    /// - Returns: A boolean value based on certain item properties
    func isReadyToBeSaved() -> Bool {
        var nameOk = false
        var groupOk = false
        if name as String? != nil && name.count > 0 {
            nameOk = true
        }
        if group != nil {
            groupOk = true
        }
        return nameOk && groupOk
    }
}
