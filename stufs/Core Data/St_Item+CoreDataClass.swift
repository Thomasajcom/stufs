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

}
