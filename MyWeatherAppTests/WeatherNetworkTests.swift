//
//  WeatherNetworkTests.swift
//  MyWeatherAppTests
//
//  Created by Ahmed Sultan on 9/3/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import XCTest
@testable import MyWeatherApp

class WeatherNetworkTests: XCTestCase {
    var mockNetworkManager: WeatherNetworkClient!
    var mockSession: MockSession!

    override func setUp() {
        super.setUp()
        mockSession = MockSession()
        mockNetworkManager = WeatherNetworkClient(session: mockSession)
    }

    override func tearDown() {
        mockSession = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testRequestSucceed() {
        let exp = expectation(description: #function)
        mockNetworkManager.fetch(forecasts: .live(city: "Berlin"),
                                 model: TestModel.self){ [weak self] (response, error)  in

            guard let self = self else { XCTFail("unknow"); return }

            if error == nil {
                XCTAssertEqual((response as? TestModel)?.name , self.mockSession.model.name)
                XCTAssertEqual(self.mockSession.urlSessionDataTaskMock.isResumedCalled, true)
            } else {
                XCTFail("decoding not work successfully")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }

    func testRequestFailed() {
        let exp = expectation(description: #function)
        mockNetworkManager.fetch(forecasts: .cached,
                                 model: String.self) {(response, error)  in
            if error != nil {
                XCTAssertEqual(error, NetworkError.faildToDecode)
            } else {
                XCTFail("decoding not work successfully")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }

    func testWeatherForecasts() {
        let liveForecastsEndPoint = WeatherForecasts.live(city: "Berlin")
        XCTAssertEqual(liveForecastsEndPoint.url?.absoluteString,
                       "\(Constants.baseURL)/forecast?q=Berlin&APPID=\(Constants.AppID)")

        let cachedForecastsEndPoint = WeatherForecasts.cached
        XCTAssert(cachedForecastsEndPoint.url?.isFileURL ?? false)
    }

    func testErrorLocalizedDescription() {
        let expected: [String] = ["missing URL",
                                  "unable to decode the response",
                                  "unknown"]

        for (index, testError) in [
            NetworkError.missingURL,
            NetworkError.faildToDecode,
            NetworkError.unknown].enumerated() {
                XCTAssertEqual(testError.rawValue, expected[index])
        }
    }
}

//MARK:- Mock Session
typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
class MockSession: URLSessionProtocol {
    var urlSessionDataTaskMock =  URLSessionDataTaskMock()
    var model = TestModel(name: "myName")

    func dataTask(with url: URL, completionHandler: @escaping MockSession.DataTaskResult) -> URLSessionDataTaskProtocol {

        let testData = try? JSONEncoder().encode(model)
        completionHandler(testData,nil,nil)


        return urlSessionDataTaskMock
    }
}

//MARK:- Mock Model
struct TestModel: Codable {
    var name: String?
}

//MARK:- Mock Data Task
class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    var isResumedCalled = false

    func resume() {
        isResumedCalled = true
    }
}
