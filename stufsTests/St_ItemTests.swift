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
    
    override func setUp() {
        super.setUp()
        coreDataStore = St_CoreDataStore(.inMemory)
        item = St_Item(context: coreDataStore.persistentContainer.viewContext)
        item.name = "iPhone 12"
        item.favorite = true
        let newGroup = St_Group(context: coreDataStore.persistentContainer.viewContext)
        newGroup.name = "New Group"
        newGroup.color = UIColor.systemGreen
        item.group = newGroup

        coreDataStore.saveContext()
    }
    
    func testToggleItemFavorite() {
        XCTAssertTrue(item.favorite)
        item.toggleFavoriteStatus()
        XCTAssertFalse(item.favorite)
    }
    
    func testCanBeSaved() {
        XCTAssertTrue(item.canBeSaved())
        item.name = ""
        XCTAssertFalse(item.canBeSaved())
    }
    
    
    override func tearDown() {
        super.tearDown()
        coreDataStore = nil
    }

}
