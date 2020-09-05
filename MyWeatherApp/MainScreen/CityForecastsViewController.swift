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
    var indicator = UIActivityIndicatorView()
    var isLive = false {
        didSet {
            modeButton.setTitle(isLive ? "live" : "cached", for: .normal)
            viewModel.mode = isLive ? .live(city: "Berlin"): .cached
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavButton()
        initVM()
    }

    func initVM(completion: (() -> Void)? = nil) {
        viewModel.fetchForcasts()
        viewModel.reloadTableClosure = { [weak self] in
            self?.tableView.reloadData()
            completion?()
        }
    }
}

//MARK:- table view datasource
extension CityForecastsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.availableDays.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastsContainerCell", for: indexPath) as! ForecastsTableViewCell
        cell.forecastsVM = viewModel.forcasts(at: indexPath.row)
        return cell
    }
}



//MARK:- Setup Menu button
extension CityForecastsViewController {
    func setupNavButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: modeButton)
        title = "Berlin Weather"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    @objc func switchMode() {
        isLive = !isLive
    }
    func createBarButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("cached", for: .normal)
        button.addTarget(self, action: #selector(switchMode), for: .touchUpInside)
        return button
    }

    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.tableView.addSubview(indicator)
    }
}
