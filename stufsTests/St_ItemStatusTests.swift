//
//  St_ItemStatusTests.swift
//  stufsTests
//
//  Created by Thomas Andre Johansen on 29/10/2020.
//
@testable import stufs
import XCTest

class St_ItemStatusTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testName() {
        for status in St_ItemStatus.allCases {
            XCTAssertFalse(status.name.isEmpty)
            if status == .favorite {
                XCTAssertTrue(status.name == "Favorite")
            } else if status == .wishlist {
                XCTAssertTrue(status.name == "Wish List")
            } else if status == .owned {
                XCTAssertTrue(status.name == "Owned")
            } else if status == .discarded {
                XCTAssertTrue(status.name == "Discarded")
            }
        }
    }
    
    func testImage() {
        for status in St_ItemStatus.allCases {
            if status == .favorite || status == .discarded {
                XCTAssertNotNil(status.image)
            } else {
                XCTAssertNil(status.image)
            }
        }
    }
    
    func testSelectedImage() {
        for status in St_ItemStatus.allCases {
            if status == .favorite || status == .discarded {
                XCTAssertNotNil(status.selectedImage)
            } else {
                XCTAssertNil(status.selectedImage)
            }
        }
    }
    
    func testInfoText() {
        for status in St_ItemStatus.allCases {
            XCTAssertFalse(status.infoText.isEmpty)
        }
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    

}
