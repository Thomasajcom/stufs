//
//  St_ItemTests.swift
//  stufsTests
//
//  Created by Thomas Andre Johansen on 05/11/2020.
//

@testable import stufs
import XCTest
import CoreData

class St_ItemTests: XCTestCase {
    
    var coreDataStore: St_CoreDataStore!
    var item: St_Item!
    var group: St_Group!
    
    override func setUp() {
        super.setUp()
        coreDataStore = St_CoreDataStore(.inMemory)
        item = St_Item(context: coreDataStore.persistentContainer.viewContext)
        item.name = "iPhone 12"
        item.favorite = true
        group = St_Group(context: coreDataStore.persistentContainer.viewContext)
        group.name = "New Group"
        group.color = UIColor.systemGreen
        item.group = group

        coreDataStore.saveContext()
    }
    
    func testToggleItemFavorite() {
        XCTAssertTrue(item.favorite)
        item.toggleFavoriteStatus()
        XCTAssertFalse(item.favorite)
    }
    
    func testIsReadyToSave() {
        XCTAssertTrue(item.isReadyToBeSaved())
        item.name = ""
        XCTAssertFalse(item.isReadyToBeSaved())
        item.name = "iPhone 12"
        item.group = nil
        XCTAssertFalse(item.isReadyToBeSaved())
        item.group = group
        XCTAssertTrue(item.isReadyToBeSaved())
    }
    
    
    override func tearDown() {
        super.tearDown()
        coreDataStore = nil
    }

}
