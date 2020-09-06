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
    lazy var statusBarLabel: UILabel = {statusLabel()}()

    var isLive = true {
        didSet {
            toggleDataSource()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavButton()
        setupTableView()
        initVM()
    }

    func setupTableView() {
        tableView.refreshControl =  UIRefreshControl()
        tableView.refreshControl?.tintColor = UIColor.systemGray
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefreshHandler), for: .valueChanged)
    }

    /// start initialize view model
    func initVM(completion: (() -> Void)? = nil) {
        viewModel.fetchForcasts()
        viewModel.reloadTableClosure = {  [weak self] success in
            guard let self = self else { return }
            guard success else {
                self.handleFailure()
                return
            }
            self.handleSucess()
            completion?()
        }
    }

    fileprivate func handleFailure() {
        statusBarLabel.text = "loading failed"
        statusBarLabel.sizeToFit()
        tableView.refreshControl?.endRefreshing()
    }

    fileprivate func handleSucess() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        statusBarLabel.text = ""
    }
    fileprivate func toggleDataSource() {
        modeButton.setTitle(isLive ? "live" : "cached", for: .normal)
        modeButton.sizeToFit()
        viewModel.mode = isLive ? .live(city: "Berlin"): .cached
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.modeButton.isEnabled = true
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "forecastsContainerCell", for: indexPath) as? ForecastsTableViewCell else { return UITableViewCell()}
        cell.isShimmeringRunning = viewModel.shimmerModelRunning
        cell.forecastsVM = viewModel.forcasts(at: indexPath.row)
        return cell
    }
}



//MARK:- Setup Menu button
extension CityForecastsViewController {
    func setupNavButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: modeButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: statusBarLabel)
        title = "Berlin Weather"
        navigationController?.navigationBar.prefersLargeTitles = true

    }

    @objc func switchMode() {
        modeButton.isEnabled = false
        isLive = !isLive
    }
    @objc func pullToRefreshHandler() {
        viewModel.fetchForcasts()
    }

    func createBarButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("live", for: .normal)
        button.addTarget(self, action: #selector(switchMode), for: .touchUpInside)
        return button
    }
    func statusLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        label.sizeToFit()
        return label
    }
}
