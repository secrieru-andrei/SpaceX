//
//  MainViewController.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 19.12.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Properties
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(LaunchTableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .clear
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpViewLayout()
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

//MARK: - View Modifiers
typealias MainViewControllerViewModifiers = MainViewController
extension MainViewControllerViewModifiers {
    func setUpView() {
        navigationItem.title = "SpaceX Launches"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .done, target: self, action: #selector(favoritesButtonTapped))
        navigationController?.navigationBar.tintColor = .systemYellow
    }
}
