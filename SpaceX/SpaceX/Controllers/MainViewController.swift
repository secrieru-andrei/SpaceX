//
//  MainViewController.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 19.12.2022.
//

import UIKit
import Combine

protocol changeFavoriteButtonState {
    func stateFavoriteButtonChanged()
    
    
}

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
        viewModel.fetchIdFromUserDefaults()
    }
}

//MARK: - Buttons Actions
typealias MainViewControllerButtonsActions = MainViewController
extension MainViewControllerButtonsActions {
    
    @objc func favoritesButtonTapped() {
        let newVc = FavoritesViewController()
        newVc.viewModel = viewModel
        newVc.favButtonDelegate = self
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(newVc, animated: false)
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
extension MainViewControllerTableViewDelegates: UITableViewDelegate, UITableViewDataSource, changeFavoriteButtonState {
    
    func stateFavoriteButtonChanged() {
        self.tableView.reloadData()
    }
    
    
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
        var markedAsFavorite = viewModel.checkLaunchIsInFavorite(launch: data)
        cell.setCell(launch: data, markedAsFavorite: markedAsFavorite)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(white: 0.2 , alpha: 0.5)
        cell.favButton.tag = indexPath.section
        
        cell.setButtonAction = {
            if markedAsFavorite == false{
                self.viewModel.favoritesCount += 1
                self.viewModel.saveToFavorites(launch: data)
                DispatchQueue.main.async {
                    cell.favButton.isHighlighted = true
                    markedAsFavorite = true
                    self.viewModel.saveData()
                }
            } else {
                self.viewModel.favoritesCount -= 1
                self.viewModel.removeFromFavorites(launch: data)
                markedAsFavorite = false
            }
        }
        return cell
    }
    
    func subscribeTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.itemIndex = indexPath.section
        guard let itemId = viewModel.launchies[viewModel.itemIndex].id else {return}
        self.viewModel.itemId = itemId

        let newVc = DetailsViewController()
        newVc.viewModel = viewModel
        newVc.loadViewIfNeeded()
        newVc.favButtonDelegate = self

        let transition = CATransition()
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(newVc, animated: false)
    }
}

//MARK: - Binding ViewModel
typealias MainViewControllerBindings = MainViewController
extension MainViewControllerBindings {
    func bindViewModel() {
        viewModel.$launchies.sink { [weak self] launch in
            self?.viewModel.launchiesCount = launch.count
            self?.subscribeTableViewDelegates()
            self?.viewModel.fillFavoritesArrayWithData(launchies: launch)
        }.store(in: &cancelabless)
    }
}
//MARK: - View Modifiers
typealias MainViewControllerViewModifiers = MainViewController
extension MainViewControllerViewModifiers {
    func setUpView() {
        navigationItem.title = "SpaceX Launches"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .done, target: self, action: #selector(favoritesButtonTapped))
        navigationController?.navigationBar.tintColor = .systemYellow
    }
}
