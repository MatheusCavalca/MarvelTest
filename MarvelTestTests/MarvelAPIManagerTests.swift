//
//  MarvelAPIManagerTests.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/16/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import XCTest
import UIKit
import AFNetworking
@testable import MarvelTest

class MarvelAPIManagerTests: XCTestCase {

    func testCharacterAPIRequest() {
        for i in 0 ..< 10 {
            let expectation = expectationWithDescription("Testing Async Method Works!")
            
            MarvelAPIManager.sharedInstance.getCharacters(i, success: { (operation, characters) in
                XCTAssertTrue(characters.count == 12, "No more characters to load")
                expectation.fulfill()
            }) { (operation, error) in
                XCTFail("Load characters failed with error: " + error.description)
            }
            
            waitForExpectationsWithTimeout(10.0, handler: { error in XCTAssertNil(error, "Expectation failed with error: " + (error?.description)!)})
        }
    }
    
}
