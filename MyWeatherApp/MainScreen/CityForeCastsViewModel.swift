//
//  CityForeCastsViewModel.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/3/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import Foundation
struct ForecastCellViewModel {
    let timeInSec: Double
    let time: String
    let date: String
    let icon: String
    let weather: String
    let temperature: String
}
class CityForeCastsViewModel {

    /// we can inject testable provider here
    var provider: WeatherNetworkClientProtocol = WeatherNetworkClient()
    var currentTask: Cancellable?

    var reloadTableClosure: (()-> Void)?
    var availableDays : [String] = []

    var forecastCellViewModels: [ForecastCellViewModel] = [] {
        didSet {
            availableDays = forecastCellViewModels.map {$0.date}.unique()
            reloadTableClosure?()
        }
    }

    var mode: WeatherForecastsMode = .cached {
        didSet {
            if mode != oldValue {
                fetchForcasts()
            }
        }
    }

    func fetchForcasts() {
        currentTask = nil
        currentTask = provider.fetch(forecasts: mode, model: ForecastsResponseModel.self) { [weak self] (forcastsModel, error) in

            guard let self = self,
                error == nil,
                let forcasts = forcastsModel as? ForecastsResponseModel,
                let list = forcasts.list else { return }

            self.forecastCellViewModels = list.compactMap { $0.mapToViewModel()}
        }
    }

    func forcasts(at index: Int) -> [ForecastCellViewModel] {
        guard  index < availableDays.count else { return []}
        let day = availableDays[index]
        return forecastCellViewModels.filter { $0.date == day}
    }

}

public extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
