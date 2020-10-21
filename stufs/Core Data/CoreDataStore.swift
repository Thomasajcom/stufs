//
//  CoreDataStore.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 21/10/2020.
//

import Foundation
import CoreData

enum StorageType {
  case persistent, inMemory
}

/// The Core Data Store in use, it uses StorageType to define what kind of
/// store should be used, this is very handy for testing.
/// for more details, see: https://www.donnywals.com/setting-up-a-core-data-store-for-unit-tests/
class CoreDataStore {
  let persistentContainer: NSPersistentCloudKitContainer

  init(_ storageType: StorageType = .persistent) {
    self.persistentContainer = NSPersistentCloudKitContainer(name: "stufs")

    //with testing we set up an inMemory store that writes to /dev/null, while undocumented this is Apple's recommended approach
    if storageType == .inMemory {
      let description = NSPersistentStoreDescription()
      description.url = URL(fileURLWithPath: "/dev/null")
      self.persistentContainer.persistentStoreDescriptions = [description]
    }

    self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
  }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
