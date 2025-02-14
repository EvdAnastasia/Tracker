//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Anastasiia on 11.02.2025.
//

import UIKit

protocol CategoriesViewControllerDelegate: AnyObject {
    func didSelectCategory(_ name: String)
}

final class CategoriesViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: CategoriesViewControllerDelegate?
    
    // MARK: - Private Properties
    private var viewModel: CategoriesViewModel
    private let trackersService = TrackersService.shared
    private var selectedCategory: String?
    
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
    
    private lazy var categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CategoriesConstants.reuseIdentifier)
        tableView.backgroundColor = .ypLightGray
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = CategoriesConstants.rowHeight
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
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
    
    // MARK: - Initializers
    init(viewModel: CategoriesViewModel, selectedCategory: String?) {
        self.viewModel = viewModel
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupConstraints()
        
        viewModel.categoriesBinding = { [weak self] categories in
            guard let self else { return }
            self.categoriesTableView.reloadData()
        }
        
        viewModel.fetchCategories()
        reloadNoCategoriesView()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Категория"
    }
    
    private func reloadNoCategoriesView() {
        let categoriesIsEmpty = viewModel.categories.isEmpty
        noCategoriesStackView.isHidden = !categoriesIsEmpty
        categoriesTableView.isHidden = categoriesIsEmpty
        
    }
    
    private func reloadTableViewHeightConstraints() {
        let tableViewHeightConstraint = categoriesTableView.constraints.first { $0.firstAttribute == .height }
        
        if let tableViewHeightConstraint {
            tableViewHeightConstraint.constant = CGFloat(75 * viewModel.categoriesAmount)
            tableViewHeightConstraint.priority = .defaultLow
            tableViewHeightConstraint.isActive = true
        }
        
        view.layoutIfNeeded()
    }
    
    private func setupConstraints() {
        [addCategoryButton,
         noCategoriesStackView,
         categoriesTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            noCategoriesStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noCategoriesStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * viewModel.categoriesAmount)),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func addCategoryButtonTapped() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        let newCategoryNavController = UINavigationController(rootViewController: newCategoryViewController)
        navigationController?.present(newCategoryNavController, animated: true)
    }
}

extension CategoriesViewController: NewCategoryViewControllerDelegate {
    func createCategory(name: String) {
        viewModel.addCategory(name)
        viewModel.fetchCategories()
        reloadNoCategoriesView()
        reloadTableViewHeightConstraints()
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.categoriesAmount
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesConstants.reuseIdentifier, for: indexPath)
        let categoryName = viewModel.getCategoryName(at: indexPath.row)
        
        cell.accessoryType = .checkmark
        cell.selectionStyle = .none
        cell.textLabel?.text = categoryName
        cell.backgroundColor = .ypLightGray
        cell.accessoryType = categoryName == selectedCategory ? .checkmark : .none
        cell.textLabel?.textColor = .ypBlack
        cell.detailTextLabel?.textColor = .ypGray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        if indexPath.row < viewModel.categoriesAmount - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        for row in 0..<viewModel.categoriesAmount {
            let currentIndexPath = IndexPath(row: row, section: 0)
            tableView.cellForRow(at: currentIndexPath)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.allowsSelection = false
        
        if let categoryName = viewModel.getCategoryName(at: indexPath.row) {
            self.delegate?.didSelectCategory(categoryName)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
