//
//  DetailsViewController.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 20.12.2022.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController {
    //MARK: - Properties
    
    var viewModel: LaunchViewModel! {
        didSet {
            bind()
        }
    }
    
    var activityIndicator: UIActivityIndicatorView!
    
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
        label.font = UIFont(name: "BanglaSangamMN", size: 14)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewLayout()
        wikipediaLink.addTarget(self, action: #selector(wikipediaButtonTapped), for: .touchUpInside)
    }
}

//MARK: - Layout
typealias DetailsViewControllerLayout = DetailsViewController
extension DetailsViewControllerLayout {
    
    func setUpViewLayout() {
        setUpVideoViewLayout()
        setUpDescriptionLabelLayout()
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
            wikipediaLink.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            wikipediaLink.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            wikipediaLink.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            wikipediaLink.heightAnchor.constraint(equalTo: descriptionLabel.heightAnchor)
        ])
    }
}

//MARK: - Binding
typealias DetailsViewControllerBinding = DetailsViewController
extension DetailsViewControllerBinding {
    
    func bind() {
        if let item = viewModel.launchies.first(where: {$0.id == viewModel.itemId}) {
            navigationItem.title = item.name
            descriptionLabel.text = "Description: " + item.details!
            
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
}
