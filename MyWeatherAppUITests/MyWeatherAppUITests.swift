//
//  MyWeatherAppUITests.swift
//  MyWeatherAppUITests
//
//  Created by Ahmed Sultan on 9/3/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import XCTest

class MyWeatherAppUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testExample() throws {
        app.launch()
        let tableViewQuery = app.tables
        XCTAssertTrue(tableViewQuery.staticTexts["timeLabelId"].exists)
        XCTAssertTrue(tableViewQuery.staticTexts["weatherDescriptionLabel"].exists)
    }

}
