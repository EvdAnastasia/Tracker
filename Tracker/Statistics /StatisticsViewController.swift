//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Anastasiia on 01.12.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Private Properties
    private let trackersService = TrackersService.shared
    private var completedTrackers: [TrackerRecord] = []
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let labelText = "Cтатистика"
        label.text = labelText
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var emptyStatisticsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "EmptySmile")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyStatisticsLabel: UILabel = {
        let label = UILabel()
        let labelText = "Анализировать пока нечего"
        label.text = labelText
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emptyStatisticsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emptyStatisticsImageView, emptyStatisticsLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var statisticsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticCell.self, forCellReuseIdentifier: StatisticsConstants.reuseIdentifier)
        tableView.backgroundColor = .ypWhite
        tableView.rowHeight = StatisticsConstants.rowHeight
        tableView.separatorStyle = .none
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureView()
        setupConstraints()
        reloadNoStatisticsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        reloadNoStatisticsView()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
    }
    
    private func loadData() {
        completedTrackers = trackersService.fetchRecords()
        statisticsTableView.reloadData()
    }
    
    private func reloadNoStatisticsView() {
        let isStatisticsEmpty = completedTrackers.isEmpty
        statisticsTableView.isHidden = isStatisticsEmpty
        emptyStatisticsStackView.isHidden = !isStatisticsEmpty
    }
    
    private func setupConstraints() {
        [titleLabel,
         emptyStatisticsStackView,
         statisticsTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            emptyStatisticsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatisticsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            statisticsTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            statisticsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            statisticsTableView.heightAnchor.constraint(equalToConstant: StatisticsConstants.rowHeight)
        ])
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = statisticsTableView.dequeueReusableCell(withIdentifier: StatisticsConstants.reuseIdentifier, for: indexPath) as? StatisticCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(
            title: StatisticsConstants.completedTrackersTitle,
            completedDays: completedTrackers.count
        )
        
        return cell
    }
}
