//
//  MarvelGeneralTests.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/16/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import XCTest
import UIKit
import AFNetworking
@testable import MarvelTest

class MarvelGeneralTests: XCTestCase {
    
    // MARK: - Life Cycle
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    // MARK: - API Requests & Data Objects initialization
    
    /**
     Verifiy if Marvel API is returning correct response for Characters request
     
     - Known bug: Sometimes Marvel API returns error `500` when fetching characters using offset and limit differents of 0.
        When this test fails, we can reproduce this issue using the interactive documentation of Marvel API on the link below, with the same `limit` and `offset` parameters:
            `http://developer.marvel.com/docs`
     */
    func testCharacterAPIRequest() {
        for i in 0 ..< 5 {
            let expectation = expectationWithDescription("Testing Characters loading for page: " + i.description)
            
            MarvelAPIManager.sharedInstance.getCharacters(i, success: { (operation, characters) in
                XCTAssertTrue(characters.count == 12, "No more characters to load at page: " + i.description)
                expectation.fulfill()
            }) { (operation, error) in
                XCTFail("Load characters failed with error: " + error.description)
            }
            
            waitForExpectationsWithTimeout(10.0, handler: { error in XCTAssertNil(error, "Expectation failed with error: " + (error?.description)!)})
        }
    }
    
    /**
     Verifiy if Marvel API is returning correct response for Characters request starting with
     
     - Known bug: Sometimes Marvel API returns error `500` when fetching characters using `offset` and `limit` differents of 0.
     When this test fails, we can reproduce this issue using the interactive documentation of Marvel API on the link below, with the same `limit`, `offset` and `nameStartsWith` parameters:
     `http://developer.marvel.com/docs`
     */
    func testCharacterWithNameAPIRequest() {
        for i in 0 ..< 2 {
            let expectation = expectationWithDescription("Testing Characters loading for Captain America and for page: " + i.description)
            
            MarvelAPIManager.sharedInstance.getCharactersWithNameStartingWith("Ca", page: i, success: { (operation, characters) in
                XCTAssertTrue(characters.count == 12, "No more characters to load at page: " + i.description)
                expectation.fulfill()
            }) { (operation, error) in
                XCTFail("Load Characters failed with error:" + error.description)
            }
            
            waitForExpectationsWithTimeout(10.0, handler: { error in XCTAssertNil(error, "Expectation failed with error: " + (error?.description)!)})
        }
    }
    
    func testComicsAPIRequest() {
        let expectation = expectationWithDescription("Testing comics loading for Wolverine")
        
        MarvelAPIManager.sharedInstance.getComicsWithCharacter(1009718, success: { (operation, appearances) in
            XCTAssertTrue(appearances.count > 0, "No comics to load")
            expectation.fulfill()
        }) { (operation, error) in
            XCTFail("Load comics failed with error: " + error.description)
        }
        
        waitForExpectationsWithTimeout(10.0, handler: { error in XCTAssertNil(error, "Expectation failed with error: " + (error?.description)!)})
    }
    
    func testSeriesAPIRequest() {
        let expectation = expectationWithDescription("Testing series loading for Wolverine")
        
        MarvelAPIManager.sharedInstance.getSeriesWithCharacter(1009718, success: { (operation, appearances) in
            XCTAssertTrue(appearances.count > 0, "No Series to load")
            expectation.fulfill()
        }) { (operation, error) in
            XCTFail("Load series failed with error: " + error.description)
        }
        
        waitForExpectationsWithTimeout(10.0, handler: { error in XCTAssertNil(error, "Expectation failed with error: " + (error?.description)!)})
    }

    func testStoriesAPIRequest() {
        let expectation = expectationWithDescription("Testing stories loading for Wolverine")
        
        MarvelAPIManager.sharedInstance.getStoriesWithCharacter(1009718, success: { (operation, appearances) in
            XCTAssertTrue(appearances.count > 0, "No stories to load")
            expectation.fulfill()
        }) { (operation, error) in
            XCTFail("Load stories failed with error: " + error.description)
        }
        
        waitForExpectationsWithTimeout(10.0, handler: { error in XCTAssertNil(error, "Expectation failed with error: " + (error?.description)!)})
    }

    func testEventsAPIRequest() {
        let expectation = expectationWithDescription("Testing events loading for Wolverine")
        
        MarvelAPIManager.sharedInstance.getEventsWithCharacter(1009718, success: { (operation, appearances) in
            XCTAssertTrue(appearances.count > 0, "No comics to load")
            expectation.fulfill()
        }) { (operation, error) in
            XCTFail("Load events failed with error: " + error.description)
        }
        
        waitForExpectationsWithTimeout(10.0, handler: { error in XCTAssertNil(error, "Expectation failed with error: " + (error?.description)!)})
    }
    
}
