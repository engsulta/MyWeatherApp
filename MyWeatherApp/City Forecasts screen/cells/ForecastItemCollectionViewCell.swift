//
//  ForecastItemCollectionViewCell.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/4/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import UIKit

class ForecastItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var averageTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        timeLabel.accessibilityIdentifier = "timeLabelId"
        weatherDescriptionLabel.accessibilityIdentifier = "weatherDescriptionLabel"
    }
    func configure(with viewModel: ForecastCellViewModel) {
        var iconName = viewModel.icon
        iconName.removeLast()
        weatherIcon.image = UIImage(named: iconName)
        let temp = Double(viewModel.temperature) ?? 0.0
        averageTempLabel.text = "\(temp) °K"
        timeLabel.text = viewModel.time
        weatherDescriptionLabel.text = viewModel.weather

    }
}

struct ForecastCellViewModel {
    let timeInSec: Double
    let time: String
    let date: String
    let icon: String
    let weather: String
    let temperature: String
}
