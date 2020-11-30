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
    
    /// Find the age of an item, based on its acquiredDate
    /// - Returns: How many days old the item is, -1 if the acquiredDate was nil
    func getItemAge() -> String {
        #warning("missing TEST")
        guard let acquiredDate = self.acquiredDate else {
            return "-1 days"
        }
        let calendar = Calendar.current
        
        let today = calendar.startOfDay(for: Date())
        let acqDate = calendar.startOfDay(for: acquiredDate)
        
        let itemAge = calendar.dateComponents([.day], from: acqDate, to: today)
        
        return "\(itemAge.day!)"
    }
}
