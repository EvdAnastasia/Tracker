//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Anastasiia on 26.02.2025.
//

import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: TrackersFilter)
}

final class FiltersViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: FiltersViewControllerDelegate?
    
    // MARK: - Private Properties
    private let userDefaultsService = UserDefaultsService.shared
    private var lastSelectedFilter: TrackersFilter?
    private let allFilters = TrackersFilter.allCases
    
    private lazy var filtersTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: FiltersConstants.reuseIdentifier)
        tableView.backgroundColor = .ypLightGray
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = FiltersConstants.rowHeight
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastSelectedFilter = allFilters.first(where: { $0.title == userDefaultsService.lastSelectedFilter })
        configureView()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Фильтры"
    }
    
    private func setupConstraints() {
        filtersTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersTableView)
        
        NSLayoutConstraint.activate([
            filtersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filtersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * allFilters.count)),
        ])
    }
    
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        allFilters.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FiltersConstants.reuseIdentifier, for: indexPath)
        let filter = allFilters[indexPath.row]
        
        cell.selectionStyle = .none
        cell.textLabel?.text = filter.title
        cell.backgroundColor = .ypLightGray
        cell.accessoryType = filter == lastSelectedFilter ? .checkmark : .none
        cell.textLabel?.textColor = .ypBlack
        cell.detailTextLabel?.textColor = .ypGray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        if indexPath.row < allFilters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        for row in 0..<allFilters.count {
            let currentIndexPath = IndexPath(row: row, section: 0)
            tableView.cellForRow(at: currentIndexPath)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.allowsSelection = false
        
        let selectedFilter = allFilters[indexPath.row]
        userDefaultsService.lastSelectedFilter = selectedFilter.title
        delegate?.didSelectFilter(allFilters[indexPath.row])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
