//
//  FavoritesViewController.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 20.12.2022.
//

import UIKit
import Combine

class FavoritesViewController: UIViewController {
    //MARK: - Properties
    
    var viewModel: LaunchViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    var favButtonDelegate: changeFavoriteButtonState!
    
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(LaunchTableViewCell.self, forCellReuseIdentifier: "favoritesCell")
        table.backgroundColor = .clear
        table.rowHeight = 200
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewLayout()
        self.navigationItem.title = "Favorites"
    }
    
}

//MARK: - Layout
typealias FavoritesViewControllerLayout = FavoritesViewController
extension FavoritesViewControllerLayout {
    
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
typealias FavoritesViewControllerTableViewDelegates = FavoritesViewController
extension FavoritesViewControllerTableViewDelegates: UITableViewDelegate, UITableViewDataSource, changeFavoriteButtonState {
    
    func stateFavoriteButtonChanged() {
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func  numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.favoritesCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as! LaunchTableViewCell
        let data = viewModel.favorites[indexPath.section]
        cell.setCell(launch: data, markedAsFavorite: true)
        cell.favButton.isEnabled = false
        cell.favButton.isHidden = true
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
        viewModel.itemIndex = indexPath.section
        guard let itemId = viewModel.favorites[viewModel.itemIndex].id else {return}
        self.viewModel.itemId = itemId
        
        let newVc = DetailsViewController()
        newVc.viewModel = viewModel
        newVc.favButtonDelegate = favButtonDelegate
        let transition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(newVc, animated: true)
    }
}

//MARK: - ViewModel Bindings
typealias FavoritesViewControllerBindings = FavoritesViewController
extension FavoritesViewControllerBindings {
    func bindViewModel() {
        viewModel.$favorites.sink { [weak self] launch in
            self?.subscribeTableViewDelegates()
        }.store(in: &cancellables)
    }
}


