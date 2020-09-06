//
//  CityForeCastsViewModel.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/3/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import Foundation

class CityForeCastsViewModel {

    /// we can inject testable provider here
    var provider: WeatherNetworkClientProtocol = WeatherNetworkClient()
    var currentTask: Cancellable?

    var reloadTableClosure: ((Bool)-> Void)?
    var availableDays : [String] = []
    var shouldShowShimmer: Bool = false
    var forecastCellViewModels: [ForecastCellViewModel] = [] {
        didSet {
            availableDays = forecastCellViewModels.map {$0.date}.unique()
            reloadTableClosure?(true)
        }
    }

    var mode: WeatherForecastsMode = .live(city: "Berlin") {
        didSet {
            if mode != oldValue {
                fetchForcasts()
            }
        }
    }

    init() {
       loadShimmeringModel()
    }

    func fetchForcasts() {
        currentTask = nil
        currentTask = provider.fetch(forecasts: mode, model: ForecastsResponseModel.self) { [weak self] (forcastsModel, error) in

            guard let self = self else {
                return
            }
            self.shouldShowShimmer = false
            guard error == nil,
                let forcasts = forcastsModel as? ForecastsResponseModel,
                let list = forcasts.list else {
                    self.reloadTableClosure?(false)
                    return
            }

            self.forecastCellViewModels = list.compactMap { $0.mapToViewModel()}
        }
    }

    func forcasts(at index: Int) -> [ForecastCellViewModel] {
        guard  index < availableDays.count else { return []}
        let day = availableDays[index]
        return forecastCellViewModels.filter { $0.date == day}
    }

}


//MARK:- shimmiring model loading
extension CityForeCastsViewModel {
    func loadShimmeringModel() {
        let filePath = Bundle.main.path(forResource: "forecasts_shimmer_model",
                                        ofType: "json") ?? ""
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath),
                                   options: .alwaysMapped) else { return }
        let decoder = JSONDecoder()
        guard let model = try? decoder.decode(ForecastsResponseModel.self, from: data).list  else {return}
        self.forecastCellViewModels = model.compactMap { $0.mapToViewModel()}
        self.shouldShowShimmer = true
    }
}

