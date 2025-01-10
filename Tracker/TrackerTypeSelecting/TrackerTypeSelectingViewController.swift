//
//  TrackerTypeSelectingViewController.swift
//  Tracker
//
//  Created by Anastasiia on 19.12.2024.
//

import UIKit

final class TrackerTypeSelectingViewController: UIViewController {
    
    // MARK: - Private Properties
    private let buttonHeight: CGFloat = 60
    private let stackViewPadding: CGFloat = 20
    
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
        
        configureView()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Создание трекера"
    }
    
    private func setupConstraints() {
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        irregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: stackViewPadding),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -stackViewPadding),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            habitButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            habitButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            habitButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor),
            
            irregularEventButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            irregularEventButton.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor),
            irregularEventButton.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor)
        ])
    }
    
    @objc private func habitButtonTapped() {
        let newHabitViewController = NewHabitViewController()
        let newHabitNavController = UINavigationController(rootViewController: newHabitViewController)
        navigationController?.present(newHabitNavController, animated: true)
    }
    
    @objc private func irregularEventButtonTapped() {
        let newIrregularEventViewController = NewIrregularEventViewController()
        let newIrregularEventNavController = UINavigationController(rootViewController: newIrregularEventViewController)
        navigationController?.present(newIrregularEventNavController, animated: true)
    }
}
