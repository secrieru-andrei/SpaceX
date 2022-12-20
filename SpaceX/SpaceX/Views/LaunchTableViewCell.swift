//
//  LaunchTableViewCell.swift
//  SpaceX
//
//  Created by Secrieru Andrei on 19.12.2022.
//

import UIKit

class LaunchTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont(name: "BanglaSangamMN-Bold", size: 20)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont(name: "BanglaSangamMN", size: 14)
        return label
    }()
    
    lazy var launchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Layout
typealias LaunchTableViewCellLayout = LaunchTableViewCell
extension LaunchTableViewCellLayout {
    
    func setUpCellLayout() {
        setUpImageLayout()
        setUpNameLabelLayout()
        setUpDateLabelLayout()
    }
    
    func setUpImageLayout() {
        addSubview(launchImage)
        launchImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            launchImage.topAnchor.constraint(equalTo: topAnchor,constant: 8),
            launchImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            launchImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            launchImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        ])
    }
    
    func setUpNameLabelLayout() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: launchImage.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: launchImage.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.2)
        ])
    }
    
    func setUpDateLabelLayout() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: launchImage.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            dateLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor)
        ])
    }
}

//MARK: - Set Cell
typealias LaunchTableViewCellSetCell = LaunchTableViewCell
extension LaunchTableViewCellSetCell {
    
    func setCell(launch: Launch) {
        nameLabel.text = launch.name
        
        let dateUnix = Double(launch.dateUnix!)
        let localDate = Date(timeIntervalSince1970: dateUnix)
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        dateFormater.dateStyle = .medium
        
        dateLabel.text = dateFormater.string(from: localDate)
        launchImage.getImageFromUrl(url: launch.links!.patch!.small!)
    }
}
