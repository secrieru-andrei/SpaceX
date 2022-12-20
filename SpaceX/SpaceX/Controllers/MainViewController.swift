//
//  MainViewController.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 19.12.2022.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    //MARK: - Properties
    var viewModel = LaunchViewModel()
    private var cancelabless: Set<AnyCancellable> = []
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(LaunchTableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .clear
        table.rowHeight = 200
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpViewLayout()
        bindViewModel()
    }
}

//MARK: - Buttons Actions
typealias MainViewControllerButtonsActions = MainViewController
extension MainViewControllerButtonsActions {
    
    @objc func favoritesButtonTapped() {
        
    }
}

//MARK: - Layout
typealias MainViewControllerLayout = MainViewController
extension MainViewControllerLayout {
    
    func setUpViewLayout() {
        setUpTableLayout()
    }
    
    func setUpTableLayout() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

//MARK: - TableView Delegates
typealias MainViewControllerTableViewDelegates = MainViewController
extension MainViewControllerTableViewDelegates: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func  numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.launchiesCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LaunchTableViewCell
        let data = viewModel.launchies[indexPath.section]
        cell.setCell(launch: data)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return cell
    }
    
    func subscribeTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemIndex = indexPath.section
        guard let itemId = viewModel.launchies[itemIndex].id else {return}
        self.viewModel.itemId = itemId
        
        let newVc = DetailsViewController()
        newVc.viewModel = viewModel
        navigationController?.pushViewController(newVc, animated: true)
    }
}

//MARK: - Binding ViewModel
typealias MainViewControllerBindings = MainViewController
extension MainViewControllerBindings {
    func bindViewModel() {
        viewModel.$launchies.sink { [weak self] launch in
            self?.viewModel.launchiesCount = launch.count
            self?.subscribeTableViewDelegates()
        }.store(in: &cancelabless)
    }
}
//MARK: - View Modifiers
typealias MainViewControllerViewModifiers = MainViewController
extension MainViewControllerViewModifiers {
    func setUpView() {
        navigationItem.title = "SpaceX Launches"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .done, target: self, action: #selector(favoritesButtonTapped))
        navigationController?.navigationBar.tintColor = .systemYellow
    }
}
