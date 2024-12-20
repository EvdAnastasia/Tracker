//
//  TrackerTypeSelectingViewController.swift
//  Tracker
//
//  Created by Anastasiia on 19.12.2024.
//

import UIKit

final class TrackerTypeSelectingViewController: UIViewController {
    
    // MARK: - Private Properties
    private let pageTitleHeight: CGFloat = 64
    private let buttonHeight: CGFloat = 60
    private let stackViewPadding: CGFloat = 20
    
    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var irregularEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(irregularEventButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [habitButton, irregularEventButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pageTitle)
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageTitle.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageTitle.heightAnchor.constraint(equalToConstant: pageTitleHeight),
            pageTitle.topAnchor.constraint(equalTo: view.topAnchor),
            
            buttonsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(stackViewPadding * 2)),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: stackViewPadding),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -stackViewPadding),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: pageTitleHeight / 2),
            
            habitButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            habitButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            habitButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor),
            
            irregularEventButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            irregularEventButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            irregularEventButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor)
        ])
    }
    
    @objc private func habitButtonTapped() {
        print("Создать привычку")
    }
    
    @objc private func irregularEventButtonTapped() {
        print("Создать нерегулярное событие")
    }
}
