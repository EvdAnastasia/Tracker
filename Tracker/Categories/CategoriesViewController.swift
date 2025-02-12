//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Anastasiia on 11.02.2025.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    // MARK: - Private Properties
    private lazy var noCategoriesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StarIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var noCategoriesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = """
        Привычки и события можно
        объединить по смыслу
        """
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var noCategoriesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noCategoriesImageView, noCategoriesLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
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
        navigationItem.title = "Категория"
    }
    
    private func setupConstraints() {
        [addCategoryButton,
         noCategoriesStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            noCategoriesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noCategoriesStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func addCategoryButtonTapped() {
        let newCategoryViewController = NewCategoryViewController()
        let newCategoryNavController = UINavigationController(rootViewController: newCategoryViewController)
        navigationController?.present(newCategoryNavController, animated: true)
    }
}
