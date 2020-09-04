//
//  ViewController.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/3/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import UIKit

class CityForecastsViewController: UITableViewController {

    var viewModel: CityForeCastsViewModel = CityForeCastsViewModel()
    lazy var modeButton: UIButton = {createBarButton()}()
    var currentMode = false {
        didSet {
            modeButton.setTitle(currentMode ? "live" : "cached", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        setupMenu()
    }

}

extension CityForecastsViewController {
    fileprivate func setupMenu() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: modeButton)
        title = "Berlin Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    @objc func switchMode() {
        currentMode = !currentMode
    }
    func createBarButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("cached", for: .normal)
        button.addTarget(self, action: #selector(switchMode), for: .touchUpInside)
        return button
    }
}
