//
//  CoreDataTests.swift
//  stufsTests
//
//  Created by Thomas Andre Johansen on 21/10/2020.
//
@testable import stufs
import XCTest
import CoreData

class CoreDataTests: XCTestCase {

    var coreDataStore: St_CoreDataStore!
    var item: St_Item!
    
    override func setUp() {
        super.setUp()
        coreDataStore = St_CoreDataStore(.inMemory)
        item = St_Item(context: coreDataStore.persistentContainer.viewContext)
        item.name = "iPhone 12"
        item.favorite = true
        coreDataStore.saveContext()
    }
    
    /// Fetching all St_Items, should only be 1, the item  created in the setUp
    func testFetchAllItems() {
        XCTAssertTrue(coreDataStore.fetchAllItems().count == 1)
    }
    
    func testAddSt_Item() {
        let newItem = St_Item(context: coreDataStore!.persistentContainer.viewContext)
        newItem.name = "iPhone 12 Pro"
        newItem.favorite = false
        newItem.acquiredFrom = "Elkjøp"
        let today = Date()
        newItem.acquiredDate = today
        newItem.discardedDate = nil
        let notes = "These are the notes for my iPhone 12 Pro I purchased from Elkjøp. It's not a favorite."
        newItem.notes = notes
        newItem.status = St_ItemStatus.owned.name
        
        XCTAssertNotNil(newItem, "Should not be nil after being created.")
        XCTAssertTrue(newItem.name == "iPhone 12 Pro")
        XCTAssertFalse(newItem.favorite)
        XCTAssertTrue(newItem.acquiredFrom == "Elkjøp")
        XCTAssertTrue(newItem.acquiredDate == today)
        XCTAssertTrue(newItem.notes == notes)
        XCTAssertTrue(newItem.status == "Owned")
        
        coreDataStore.saveContext()
        
        XCTAssertTrue(coreDataStore.fetchAllItems().count > 1)


        // Then you can use your properties.

    }
    
    func testToggleItemFavorite() {
        XCTAssertTrue(item.favorite)
        item.toggleFavoriteStatus()
        XCTAssertFalse(item.favorite)
    }
    
    func testDeleteItem() {
        coreDataStore.deleteAll(ofEntity: "St_Item")
        XCTAssertTrue(coreDataStore.fetchAllItems().count == 0)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStore = nil
    }

}
