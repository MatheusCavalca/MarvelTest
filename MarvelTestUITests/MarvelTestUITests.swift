//
//  MarvelTestUITests.swift
//  MarvelTestUITests
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//


import XCTest
import UIKit
import AFNetworking
@testable import MarvelTest

class MarvelTestUITests: XCTestCase {
    
    // MARK: - Life Cycle
    
    override func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - General UI Tests
    
    func testCharacterTableViewScroll() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let table = tablesQuery.element
        while (tablesQuery.cells.count < 50) {
            table.swipeUp()
        }
    }
    
    func testSearchCharacter() {
        let app = XCUIApplication()
        app.buttons["icn nav search"].tap()
        app.textFields["Search..."].tap()
        app.textFields["Search..."].typeText("Dead")
        sleep(5)
        XCTAssertTrue(app.tables.cells.count > 0, "Search for character didn't work or timeout occured")
    }
    
    func testCharacterRelatedLinks() {
        let tablesQuery = XCUIApplication().tables
        let app = XCUIApplication()
        
        sleep(5)
        XCTAssertTrue(app.tables.cells.count > 0, "Characters not loaded or timeout occured")
        
        let staticText = tablesQuery.staticTexts["3-D Man"]
        staticText.tap()
        tablesQuery.staticTexts["Detail"].tap()
        app.buttons["Done"].tap()
        tablesQuery.staticTexts["Wiki"].tap()
        app.buttons["Done"].tap()
        tablesQuery.staticTexts["Comiclink"].tap()
        app.buttons["Done"].tap()
    }
    
}
