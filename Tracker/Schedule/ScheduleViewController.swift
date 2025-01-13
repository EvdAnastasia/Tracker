//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Anastasiia on 25.12.2024.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSelectSchedule(for days: [WeekDay])
}

final class ScheduleViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: ScheduleViewControllerDelegate?
    
    // MARK: - Private Properties
    private let weekDays: [WeekDay] = WeekDay.allCases
    private var selectedDays: Set<WeekDay> = []
    
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
    
    // MARK: - Initializers
    init(selectedDays: Set<WeekDay>) {
        super.init(nibName: nil, bundle: nil)
        self.selectedDays = selectedDays
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Расписание"
    }
    
    private func setupConstraints() {
        [scheduleTableView,
         doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: ScheduleConstants.cellHeight * CGFloat(weekDays.count)),
            
            doneButton.heightAnchor.constraint(equalToConstant: ScheduleConstants.doneButtonHeight),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    @objc
    private func doneButtonTapped() {
        let sortedDay = selectedDays.sorted { $0.rawValue < $1.rawValue }
        delegate?.didSelectSchedule(for: sortedDay)
        navigationController?.dismiss(animated: true)
    }
}

extension ScheduleViewController: ScheduleTableViewCellDelegate {
    func didChangeSwitchState(for index: Int, isOn: Bool) {
        let day = weekDays[index]
        
        if isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        weekDays.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier, for: indexPath)
        
        guard let scheduleCell = cell as? ScheduleTableViewCell else { return UITableViewCell() }
        scheduleCell.delegate = self
        
        let dayName = weekDays[indexPath.row].getFullDayName()
        let index = weekDays[indexPath.row].rawValue - 1
        let switchStatus = selectedDays.contains(weekDays[indexPath.row])
        
        scheduleCell.configureCell(dayName: dayName, index: index, switchStatus: switchStatus)
        
        if indexPath.row == weekDays.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        }
        
        return scheduleCell
    }
}
