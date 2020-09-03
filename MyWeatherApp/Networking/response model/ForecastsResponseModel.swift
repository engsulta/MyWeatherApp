//
//  ForecastsResponseModel.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/3/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import Foundation

struct ForecastsResponseModel : Decodable {
    let list : [List]?

    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

struct List : Decodable {
    let time : Int?
    let timeTxt : String?
    let main : Main?
    let weather : [Weather]?

    enum CodingKeys: String, CodingKey {
        case time = "dt"
        case timeTxt = "dt_txt"
        case main
        case weather = "weather"
    }
}

struct Weather : Codable {

    let descriptionField : String?
    let icon : String?
    let main : String?


    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case icon = "icon"
        case main = "main"
    }
}


struct Main : Codable {

    let temp : Float?
    let tempMax : Float?
    let tempMin : Float?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}
