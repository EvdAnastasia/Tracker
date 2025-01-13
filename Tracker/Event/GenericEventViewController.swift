//
//  GenericEventViewController.swift
//  Tracker
//
//  Created by Anastasiia on 20.12.2024.
//

import UIKit

final class GenericEventViewController: UIViewController {
    // MARK: - Private Properties
    private var eventType: EventType
    private let trackersService = TrackersService.shared
    private var selectedDays: [WeekDay] = []
    private var habitOptions: [String] = []
    private var reuseIdentifier: String = ""
    private var navigationTitle: String = ""
    private var habitOptionsTableViewHeight = GenericEventConstants.habitOptionsTableViewHeight
    
    private lazy var nameField: UITextField = {
        let textField = CustomTextField(padding: GenericEventConstants.nameFieldPadding)
        textField.backgroundColor = .ypLightGray
        textField.layer.cornerRadius = 16
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .ypBlack
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(nameFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var cautionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение \(GenericEventConstants.nameTextLimit) символов"
        label.textColor = .ypRed
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameFieldStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameField, cautionLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var habitOptionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .ypLightGray
        tableView.layer.cornerRadius = 16
        tableView.rowHeight = GenericEventConstants.habitOptionsTableViewRowHeight
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        let borderColor: UIColor = .ypRed
        button.setTitle("Отменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypRed, for: .normal)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor.cgColor
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhite, for: .normal)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    // MARK: - Initializers
    init(eventType: EventType) {
        self.eventType = eventType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureUI()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = navigationTitle
    }
    
    private func configureUI() {
        switch eventType {
        case .habit:
            reuseIdentifier = "HabitOptionCell"
            habitOptions = ["Категория", "Расписание"]
            habitOptionsTableViewHeight = 150
            navigationTitle = "Новая привычка"
        case .irregular:
            reuseIdentifier = "IrregularEventOptionCell"
            habitOptions = ["Категория"]
            habitOptionsTableViewHeight = 75
            navigationTitle = "Новое нерегулярное событие"
        }
    }
    
    private func updateCreateButtonState() {
        let notEmpty = (nameField.text?.isEmpty == false) &&
        (eventType == EventType.habit ? !selectedDays.isEmpty : true)
        
        createButton.backgroundColor = notEmpty ? .ypBlack : .ypGray
        createButton.isEnabled = notEmpty
    }
    
    private func setupConstraints() {
        [nameFieldStackView,
         habitOptionsTableView,
         buttonsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            nameFieldStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: GenericEventConstants.nameFieldHeight),
            
            habitOptionsTableView.topAnchor.constraint(equalTo: nameFieldStackView.bottomAnchor, constant: 24),
            habitOptionsTableView.leadingAnchor.constraint(equalTo: nameFieldStackView.leadingAnchor),
            habitOptionsTableView.trailingAnchor.constraint(equalTo: nameFieldStackView.trailingAnchor),
            habitOptionsTableView.heightAnchor.constraint(equalToConstant: habitOptionsTableViewHeight),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: GenericEventConstants.buttonsStackViewHeight),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showScheduleViewController() {
        let days = Set(selectedDays)
        let scheduleViewController = ScheduleViewController(selectedDays: days)
        scheduleViewController.delegate = self
        let scheduleNavController = UINavigationController(rootViewController: scheduleViewController)
        navigationController?.present(scheduleNavController, animated: true)
    }
    
    @objc private func nameFieldDidChange() {
        updateCreateButtonState()
    }
    
    @objc private func cancelButtonTapped() {
        view?.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let title = nameField.text else { return }
        let isHabit = eventType == EventType.habit
        let schedule = isHabit ? selectedDays : []
        
        let newTracker = Tracker(
            id: UUID(),
            title: title,
            color: .ypColorSelection13,
            emoji: "✅",
            schedule: schedule,
            isHabit: isHabit
        )
        
        trackersService.addTracker(tracker: newTracker, for: GenericEventMockData.categoryName)
        view?.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc private func hideKeyboard() {
        view?.endEditing(true)
    }
}

extension GenericEventViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(for days: [WeekDay]) {
        selectedDays = days
        habitOptionsTableView.reloadData()
        updateCreateButtonState()
    }
}

extension GenericEventViewController: UITextFieldDelegate {
    // механика показа нотификации при превышении лимита символов в текстовом поле
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let currentText = textField.text ?? ""
        
        // Вычисляем количество символов после изменения
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let moreThanLimit = updatedText.count > GenericEventConstants.nameTextLimit
        cautionLabel.isHidden = !moreThanLimit
        return !moreThanLimit
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension GenericEventViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        habitOptions.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = habitOptions[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = .ypLightGray
        cell.textLabel?.textColor = .ypBlack
        cell.detailTextLabel?.textColor = .ypGray
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        if indexPath.row == habitOptions.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        
        let option = habitOptions[indexPath.row]
        configureDetailText(for: cell, with: option)
        
        return cell
    }
    
    private func configureDetailText(
        for cell: UITableViewCell,
        with option: String
    ) {
        if option == "Категория" {
            cell.detailTextLabel?.text = GenericEventMockData.categoryName
        } else if option == "Расписание" && !selectedDays.isEmpty {
            if selectedDays.count == 7 {
                cell.detailTextLabel?.text = "Каждый день"
            } else {
                var titleDays: [String] = []
                for day in selectedDays {
                    titleDays.append(day.getShortDayName())
                    cell.detailTextLabel?.text = titleDays.joined(separator: ", ")
                }
            }
        }
    }
}

extension GenericEventViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let option = habitOptions[indexPath.row]
        if option == "Категория" {
            // TODO: - Реализовать логику перехода на экран Категорий
        } else if option == "Расписание" {
            showScheduleViewController()
        }
    }
}
