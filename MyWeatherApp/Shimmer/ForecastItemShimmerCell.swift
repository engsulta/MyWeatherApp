//
//  ForecastItemShimmerCell.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/6/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import UIKit
class ForecastItemShimmerCell: UICollectionViewCell {

    @IBOutlet var shimmersViews: [ShimmerView]!

    override func awakeFromNib() {
        super.awakeFromNib()
        startShimmer()
    }

    func startShimmer() {
        shimmersViews.forEach { (shimmerdView) in
            shimmerdView.startAnimation()
            shimmerdView.layer.cornerRadius = shimmerdView.frame.height / 2
        }
    }
}
