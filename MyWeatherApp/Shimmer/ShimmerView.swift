//
//  ShimmerView.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/6/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import UIKit
public class ShimmerView: UIView {
    let gradientColorOne = UIColor.ShimmerViewEdge.cgColor
    let gradientColorTwo = UIColor.ShimmerViewCenter.cgColor

    public func startAnimation(duration: TimeInterval = 1.0,
                               completion: (() -> Void)? = nil) {
        self.layer.cornerRadius = 10
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.layer.masksToBounds = true
            let gradientLayer = CAGradientLayer()
            var frame = self.bounds
            frame.size.width *= 2
            gradientLayer.frame = frame
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.colors = [self.gradientColorOne, self.gradientColorTwo, self.gradientColorOne]
            gradientLayer.locations = [0.0, 0.25, 0.75]
            self.layer.addSublayer(gradientLayer)
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = [-1, -0.75, -0.25]
            animation.toValue = [1, 1.25, 1.75]
            animation.repeatCount = .infinity
            animation.duration = duration
            gradientLayer.add(animation, forKey: animation.keyPath)
            completion?()
        }
    }
}

extension UIColor {
    public static let ShimmerViewEdge = UIColor.init(named: "ShimmerViewEdge",
                                                        in: Bundle.main,
                                                        compatibleWith: nil) ?? UIColor.white

    public static let ShimmerViewCenter = UIColor.init(named: "ShimmerViewCenter",
                                                          in: Bundle.main,
                                                          compatibleWith: nil) ?? UIColor.white

}
