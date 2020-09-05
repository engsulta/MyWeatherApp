//
//  ForecastsResponseModel.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/3/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import Foundation

struct ForecastsResponseModel : Decodable {
    let list : [ForecastDetails]?

    enum CodingKeys: String, CodingKey {
        case list = "list"
    }
}

struct ForecastDetails : Decodable {
    let time : Double?
    let timeTxt : String?
    let tempreatureMain : TempreatureMain?
    let weather : [Weather]?

    enum CodingKeys: String, CodingKey {
        case time = "dt"
        case timeTxt = "dt_txt"
        case tempreatureMain = "main"
        case weather = "weather"
    }

    // put it in extension
    func mapToViewModel() -> ForecastCellViewModel {
        let time = timeTxt?.components(separatedBy: " ")[1] ?? ""// make it save
        let date = timeTxt?.components(separatedBy: " ").first ?? ""
        let icon = weather?.first?.icon ?? ""
        let weatherDesc = weather?.first?.descriptionField ?? ""
        let tempreature = tempreatureMain?.temp ?? 0
        return ForecastCellViewModel(timeInSec: self.time ?? 0,
                                     time: time,
                                     date: date,
                                     icon: icon,
                                     weather:weatherDesc,
                                     temperature: "\(tempreature)")
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


struct TempreatureMain : Codable {

    let temp : Float?
    let tempMax : Float?
    let tempMin : Float?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
    }
}
