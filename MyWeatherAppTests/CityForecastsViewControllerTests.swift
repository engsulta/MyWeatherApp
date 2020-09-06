//
//  CityForecastsViewControllerTests.swift
//  MyWeatherAppTests
//
//  Created by Ahmed Sultan on 9/5/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

class CityForecastsViewControllerTests: XCTestCase {
    var viewController: CityForecastsViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let storyboardVC = storyboard.instantiateViewController(withIdentifier: "CityForecastsViewController") as! CityForecastsViewController
        viewController = storyboardVC

        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    func testSwitch() {
        XCTAssertEqual(viewController.viewModel.mode, .cached )
        viewController.switchMode()
        XCTAssertEqual(viewController.viewModel.mode, .live(city: "Berlin") )
    }
    func testSetupNavButton() {
        viewController.setupNavButton()
        XCTAssertEqual(viewController.title, "Berlin Weather" )
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    func testMapForecast() {
        let forcastDetails = ForecastDetails(time: 1599242400, timeTxt: "2020-09-04 18:00:00", tempreatureMain: nil, weather: nil)
        let output = forcastDetails.mapToViewModel()
        XCTAssertEqual(output.date, "2020-09-04")
        XCTAssertEqual(output.time, "18:00:00")
    }
    func testInitVM() {
        let exp = expectation(description: #function)
        viewController.initVM {
            XCTAssert(true)
            exp.fulfill()
        }
         wait(for: [exp], timeout: 2.0)
    }

}
