//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Anastasiia on 01.12.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .ypBlack
        label.font = .boldSystemFont(ofSize: 34.0)
        return label
    }()
    
    private lazy var addTrackerButton: UIBarButtonItem = {
        let addImage = UIImage(named: "AddIcon")
        let button = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(addNewTracker))
        button.tintColor = .ypBlack
        return button
    }()
    
    private lazy var noTrackersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StarIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var noTrackersLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12.0)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var noTrackersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noTrackersImageView, noTrackersLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationItem.leftBarButtonItem = addTrackerButton
        
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        noTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        noTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        noTrackersStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        view.addSubview(noTrackersStackView)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            
            noTrackersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTrackersStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func addNewTracker() {
        print("Add new tracker")
    }
}
