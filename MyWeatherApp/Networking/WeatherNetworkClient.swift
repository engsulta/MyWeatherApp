//
//  WeatherNetworkClient.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/3/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import Foundation
typealias NetworkCompletion = ( _ response: Decodable?,_ error: NetworkError?) -> Void

/// protocol for the weather api client
protocol WeatherNetworkClientProtocol {
    var session: URLSessionProtocol { get }
    @discardableResult
    func fetch<T:Decodable>(forecasts: WeatherForecastsMode, model: T.Type, completion: @escaping NetworkCompletion) -> Cancellable?
}

/// concrete implementation for the weather client protocol
class WeatherNetworkClient: WeatherNetworkClientProtocol {
    var session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

//MARK:- fetch implementation
extension WeatherNetworkClient {
    @discardableResult
    func fetch<T:Decodable>(forecasts: WeatherForecastsMode,
                            model: T.Type,
                            completion: @escaping NetworkCompletion) -> Cancellable? {
    
        guard let url = forecasts.url else {
            DispatchQueue.main.async {
                completion(nil, NetworkError.missingURL)
            }
            return nil
        }

        let currentTask = session.dataTask(with: url,
                                           completionHandler: { (data, response, error) in
            guard let jsonData = data else {
                DispatchQueue.main.async {completion(nil, NetworkError.unknown)}
                return}
            do {
                let responseModel = try JSONDecoder().decode(model, from: jsonData)
                print(responseModel)

                DispatchQueue.main.async {
                    completion(responseModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, NetworkError.faildToDecode)
                }
            }
        })

        currentTask.resume()
        return currentTask
    }
}
/// WeatherEndPoint represent the available end points for the api
enum WeatherForecastsMode: Equatable {
    case live(city: String)
    case cached

    var url: URL? {
        switch self {
        case let .live(city):
            return URL(string:"\(Constants.baseURL)/forecast?q=\(city)&APPID=\(Constants.AppID)")
        case .cached:
            return Bundle.main.url(forResource: "forecasts_stub",withExtension: "json")
        }
    }
}
protocol Cancellable {
    func cancel()
}
