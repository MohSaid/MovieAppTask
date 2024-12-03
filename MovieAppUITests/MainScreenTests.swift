//
//  MainScreenTests.swift
//  MovieApp
//
//  Created by Mohamed Saeed on 03/12/2024.
//

import XCTest

class MainScreenTests: XCTestCase {
    
    func testMainScreenUI() throws {
        let app = XCUIApplication()
        app.launch()

        // Test if the search bar exists
        let searchBar = app.textFields["SearchBar"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5), "Search bar should be visible.")
        
        let genreList = app.tables["genreList"]
             XCTAssertTrue(genreList.waitForExistence(timeout: 5), "Genre list should be visible on the screen.")
        
    }
}
