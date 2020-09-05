//
//  ForecastsTableViewCell.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/4/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import UIKit

class ForecastsTableViewCell: UITableViewCell {
    @IBOutlet weak var forecastsCollectionView: UICollectionView!
    @IBOutlet weak var dayTitle: UILabel!

    let inset: CGFloat = 0
    let spacing: CGFloat = 0
    let forecastsEstimatedWidth: CGFloat = 100
    let forecastsIntermidiateSpacing: CGFloat = 0
    let forecastItemCellNibName = "forecastItemCell"
    let forecastItmeCellId = "ForecastItemCollectionViewCellID"

    var forecastsVM: [ForecastCellViewModel] = [] {
        didSet {
            forecastsCollectionView.reloadData()
            dayTitle.text = forecastsVM.first?.date ?? ""
            self.layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupforecastsCollectionView()
    }

    func setupforecastsCollectionView() {
        forecastsCollectionView.delegate = self
        forecastsCollectionView.dataSource = self
        forecastsCollectionView.accessibilityIdentifier = "ForeCastMainCard"
    }
}


extension ForecastsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastsVM.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: forecastItmeCellId, for: indexPath) as! ForecastItemCollectionViewCell
        cell.configure(with: forecastsVM[indexPath.row])
        return cell
    }

}
