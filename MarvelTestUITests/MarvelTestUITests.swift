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
        
    override func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }
    
    func testCharacterTableViewScroll() {
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["3-D Man"].swipeUp()
        tablesQuery.staticTexts["Adam Warlock"].swipeUp()
    }
    
    func testSearchCharacter() {
        let app = XCUIApplication()
        app.buttons["icn nav search"].tap()
        app.textFields["Search..."].tap()
        app.textFields["Search..."].typeText("Dead")
        sleep(5)
        XCTAssertTrue(app.tables.cells.count > 0, "Search for character didn't work or timeout occured")
    }
    
}
