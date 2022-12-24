//
//  DetailsViewController.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 20.12.2022.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController  {
    //MARK: - Properties
    
    var viewModel: LaunchViewModel! {
        didSet {
            bind()
        }
    }
    
    var favButtonDelegate: changeFavoriteButtonState!
    
    private var isInFavorites: Bool = false
    
    lazy var videoView: WKWebView = {
        let webConfig = WKWebViewConfiguration()
        webConfig.allowsInlineMediaPlayback = true
        let view = WKWebView(frame: .zero, configuration: webConfig)
        view.scrollView.isScrollEnabled = false
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.font = UIFont(name: "BanglaSangamMN", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var wikipediaLink: UIButton = {
        let btn = UIButton(configuration: .plain())
        btn.configuration?.title = "Read more on wikipedia"
        btn.configuration?.titleAlignment = .leading
        btn.titleLabel?.textColor = .link
        return btn
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Add to favorites"
        label.numberOfLines = 1
        label.font = UIFont(name: "BanglaSangamMN", size: 16 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var favButton: UIButton = {
        let btn = UIButton()
        let starImage = UIImage(systemName: "star")
        let starFilledImage = UIImage(systemName: "star.fill")
        btn.setImage(starImage, for: .normal)
        btn.tintColor = .systemYellow
        btn.setImage(starFilledImage, for: .highlighted)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewLayout()
        wikipediaLink.addTarget(self, action: #selector(wikipediaButtonTapped), for: .touchUpInside)
        favButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftGesture))
        rightGesture.direction = .right
        self.view.addGestureRecognizer(rightGesture)
        
    }
}

//MARK: - Layout
typealias DetailsViewControllerLayout = DetailsViewController
extension DetailsViewControllerLayout {
    
    func setUpViewLayout() {
        setUpVideoViewLayout()
        setUpDescriptionLabelLayout()
        setUpLabelLayout()
        setUpFavoriteButton()
        setUpWikipediaButtonLayout()
    }
    
    func setUpVideoViewLayout() {
        self.view.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            videoView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            videoView.heightAnchor.constraint(lessThanOrEqualTo: self.view.widthAnchor, multiplier: 9/16)
            
        ])
    }
    
    func setUpDescriptionLabelLayout() {
        self.view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(lessThanOrEqualTo: self.view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    func setUpWikipediaButtonLayout() {
        self.view.addSubview(wikipediaLink)
        wikipediaLink.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wikipediaLink.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16),
            wikipediaLink.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            wikipediaLink.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            wikipediaLink.heightAnchor.constraint(equalTo: descriptionLabel.heightAnchor)
        ])
    }
    
    func setUpFavoriteButton() {
        view.addSubview(favButton)
        NSLayoutConstraint.activate([
            favButton.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            favButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favButton.widthAnchor.constraint(equalToConstant: 50),
            favButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setUpLabelLayout() {
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 16),
            textLabel.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: 0.3),
            textLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
}

//MARK: - Binding
typealias DetailsViewControllerBinding = DetailsViewController
extension DetailsViewControllerBinding {
    
    func bind() {
        if let item = viewModel.launchies.first(where: {$0.id == viewModel.itemId}) {
            self.isInFavorites = self.viewModel.checkLaunchIsInFavorite(launch: item)
            favButtonState()
            navigationItem.title = item.name
            if let description = item.details {
                descriptionLabel.text = "Description: " + description
            }
            
            if ((item.links?.webcast) != nil), item.links?.youtubeID != nil {
                let urlString = item.links!.webcast! + item.links!.youtubeID!
                let url = URL(string: urlString)
                let urlRequest = URLRequest(url: url!)
                self.videoView.load(urlRequest)
                
            }
        }
    }
}

//MARK: - Buttons Actions
typealias DetailsViewControllerButtonAction = DetailsViewController
extension DetailsViewControllerButtonAction {
    @objc func wikipediaButtonTapped() {
        if let item = viewModel.launchies.first(where: {$0.id == viewModel.itemId}) {
            guard let url = URL(string: item.links!.wikipedia!) else {return}
            UIApplication.shared.open(url)
        }
    }
    
    @objc func favButtonTapped() {
        if isInFavorites == false{
            viewModel.favoritesCount += 1
            viewModel.saveToFavorites(launch: viewModel.launchies[viewModel.itemIndex])
            DispatchQueue.main.async {
                self.favButton.isHighlighted = true
                self.isInFavorites = true
                self.viewModel.saveData()
            }
        } else {
            let newVc = FavoritesViewController()
            viewModel.favoritesCount -= 1
            print(viewModel.itemIndex)
            viewModel.removeFromFavorites(launchId: viewModel.itemId)
            newVc.viewModel = self.viewModel
            self.isInFavorites = false
        }
        favButtonDelegate.stateFavoriteButtonChanged()
    }
    
    @objc func leftGesture() {
        self.navigationController?.popViewController(animated: false)
    }
    
    func favButtonState() {
        if isInFavorites == true {
            favButton.isHighlighted = true
        } else {
            favButton.isHighlighted = false
        }
    }
}

