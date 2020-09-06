//
//  NetworkHelperProtocols.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/3/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//


import Foundation

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
   
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask
    }
}


protocol URLSessionDataTaskProtocol: Cancellable {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}



struct Constants {
    static let AppID = "441258ea935cd4826dc55d83ec29fb7a"
    static let baseURL = "https://api.openweathermap.org/data/2.5"
}

enum NetworkError: String, Error{
    case missingURL = "missing URL"
    case faildToDecode = "unable to decode the response"
    case noNetwork = "unknown"
}
