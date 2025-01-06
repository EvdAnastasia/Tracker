//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Anastasiia on 25.12.2024.
//

import UIKit

final class ScheduleViewController: UIViewController, ScheduleTableViewCellDelegate {
    var selectedDays: Set<WeekDay> = []
    
    // MARK: - Private Properties
    private let weekDays: [WeekDay] = [ .monday, .tuersday, .wednesday, .thursday, .friday, .saturday, .sunday ]
    private let cellHeight: CGFloat = 75
    private let doneButtonHeight: CGFloat = 60
    
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.tableHeaderView = UIView()
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationItem.title = "Расписание"
        
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scheduleTableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: cellHeight * CGFloat(weekDays.count)),
            
            doneButton.heightAnchor.constraint(equalToConstant: doneButtonHeight),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    @objc
    private func doneButtonTapped() {
        print("doneButtonTapped")
        //        let sortedDay = selectedDays.sorted { $0.rawValue < $1.rawValue }
        //        delegate?.didSelectSchedule(for: sortedDay)
        //        navigationController?.dismiss(animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier, for: indexPath)
        
        guard let scheduleCell = cell as? ScheduleTableViewCell else { return UITableViewCell() }
        scheduleCell.delegate = self
        
        let dayName = weekDays[indexPath.row].getFullDayName()
        let switchStatus = false
        
        scheduleCell.configureCell(dayName: dayName, switchStatus: switchStatus)
        
        if indexPath.row == weekDays.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        }
        
        return scheduleCell
    }
}
