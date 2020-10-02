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
    var isShimmeringRunning = false
    let forecastItmeCellId = "ForecastItemCollectionViewCell"
    let forecastItemShimmerId = "forecastItemShimmerId"

    var forecastsVM: [ForecastCellViewModel] = [] {
        didSet {
            forecastsCollectionView.performBatchUpdates({ [weak self] in
                let indexSet = IndexSet(integer: 0)
                self?.forecastsCollectionView?.reloadSections(indexSet)
            })
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
        let forecastCell = UINib(nibName: forecastItmeCellId, bundle: Bundle.main)
        forecastsCollectionView.register(forecastCell,
                                         forCellWithReuseIdentifier: forecastItmeCellId)
        let shimmerCell = UINib(nibName: "ForecastItemShimmerCell", bundle: Bundle.main)
        forecastsCollectionView.register(shimmerCell,
                                         forCellWithReuseIdentifier: forecastItemShimmerId)
    }
}

extension ForecastsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastsVM.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isShimmeringRunning {
            dayTitle.text = ""
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: forecastItemShimmerId, for: indexPath) as! ForecastItemShimmerCell
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: forecastItmeCellId, for: indexPath) as! ForecastItemCollectionViewCell
            cell.configure(with: forecastsVM[indexPath.row])
            return cell
        }
    }
}

extension ForecastsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: collectionView.frame.height)
    }
}
