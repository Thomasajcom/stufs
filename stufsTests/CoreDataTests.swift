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
        let newGroup = St_Group(context: coreDataStore.persistentContainer.viewContext)
        newGroup.name = "New Group"
        newGroup.color = UIColor.systemGreen

        coreDataStore.saveContext()
    }
    
    /// Fetching all St_Item, should only be 1, the item  created in the setUp
    func testFetchAllItems() {
        XCTAssertTrue(coreDataStore.fetchAllItems().count == 1)
    }
    
    /// Fetching all St_Group, should only be 1, the group created in the setUp
    func testFetchAllGroups() {
        XCTAssertTrue(coreDataStore.fetchAllGroups().count == 1)
    }
    
    func testAddSt_Group() {
        let newGroup = St_Group(context: coreDataStore.persistentContainer.viewContext)
        newGroup.name = "New Group"
        newGroup.color = UIColor.systemGreen
        XCTAssertNotNil(newGroup, "Should not be nil after being created.")
        XCTAssertTrue(newGroup.name == "New Group")
        XCTAssertNotNil(newGroup.color)
        coreDataStore.saveContext()
        
        XCTAssertTrue(coreDataStore.fetchAllGroups().count > 0)
    }
    
    func testAddSt_Item() {
        let newItem = St_Item(context: coreDataStore!.persistentContainer.viewContext)
        newItem.name = "iPhone 12 Pro"
        newItem.group = coreDataStore.fetchAllGroups().first
        newItem.favorite = false
        newItem.acquiredFrom = "Elkjøp"
        let today = Date()
        newItem.acquiredDate = today
        newItem.discardedDate = nil
        let notes = "This is not a favorite. I did not buy AppleCare+ for this product."
        newItem.notes = notes
        newItem.status = St_ItemStatus.owned.name
        
        XCTAssertNotNil(newItem, "Should not be nil after being created.")
        XCTAssertNotNil(newItem.group)
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
    
    func testDeleteAllItems() {
        coreDataStore.deleteAll(ofEntity: "St_Item")
        XCTAssertTrue(coreDataStore.fetchAllItems().count == 0)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStore = nil
    }

}
