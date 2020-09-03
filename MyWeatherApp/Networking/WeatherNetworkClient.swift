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
    func fetch<T:Decodable>(forecasts: WeatherForecasts, model: T.Type, completion: @escaping NetworkCompletion)
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
    func fetch<T:Decodable>(forecasts: WeatherForecasts,
                            model: T.Type,
                            completion: @escaping NetworkCompletion) {
    
        guard let url = forecasts.url else {
            DispatchQueue.main.async {
                completion(nil, NetworkError.missingURL)
            }
            return
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
    }
}
/// WeatherEndPoint represent the available end points for the api
enum WeatherForecasts {
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
