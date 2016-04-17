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
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
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
