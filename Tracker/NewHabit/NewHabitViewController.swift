//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Anastasiia on 20.12.2024.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
    // MARK: - Private Properties
    private var categoryName: String? = "Важное" // моковые данные, далее необходимо убрать после реализации создания категории
    private var selectedDays: [WeekDay] = []
    private let reuseIdentifier = "HabitOptionCell"
    private let habitOptions: [String] = ["Категория", "Расписание"]
    private let trackersService = TrackersService.shared
    
    private let nameTextLimit = 38
    private let nameFieldHeight: CGFloat = 75
    private let habitOptionsTableViewHeight: CGFloat = 150
    private let habitOptionsTableViewRowHeight: CGFloat = 75
    private let buttonsStackViewHeight: CGFloat = 60
    private let nameFieldPadding: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 45)
    
    lazy var nameField: UITextField = {
        let textField = CustomTextField(padding: nameFieldPadding)
        textField.backgroundColor = .ypLightGray
        textField.layer.cornerRadius = 16
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textColor = .ypBlack
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(nameFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var cautionLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение \(nameTextLimit) символов"
        label.textColor = .ypRed
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.isHidden = true
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
        tableView.rowHeight = habitOptionsTableViewRowHeight
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
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func updateCreateButtonState() {
        if let name = nameField.text,
           !name.isEmpty,
           !selectedDays.isEmpty
        {
            createButton.backgroundColor = .ypBlack
            createButton.isEnabled = true
        } else {
            createButton.backgroundColor = .ypGray
            createButton.isEnabled = false
        }
    }
    
    private func configureView() {
        view.backgroundColor = .ypWhite
        navigationItem.title = "Новая привычка"
    }
    
    private func setupConstraints() {
        nameFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        nameField.translatesAutoresizingMaskIntoConstraints = false
        cautionLabel.translatesAutoresizingMaskIntoConstraints = false
        habitOptionsTableView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameFieldStackView)
        view.addSubview(habitOptionsTableView)
        view.addSubview(buttonsStackView)
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            nameFieldStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: nameFieldHeight),
            
            habitOptionsTableView.topAnchor.constraint(equalTo: nameFieldStackView.bottomAnchor, constant: 24),
            habitOptionsTableView.leadingAnchor.constraint(equalTo: nameFieldStackView.leadingAnchor),
            habitOptionsTableView.trailingAnchor.constraint(equalTo: nameFieldStackView.trailingAnchor),
            habitOptionsTableView.heightAnchor.constraint(equalToConstant: habitOptionsTableViewHeight),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: buttonsStackViewHeight),
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
        guard let title = nameField.text, let categoryName else { return }
        
        let newTracker = Tracker(
            id: UUID(),
            title: title,
            color: .ypColorSelection13,
            emoji: "✅",
            schedule: selectedDays,
            isHabit: true
        )
        
        trackersService.addTracker(tracker: newTracker, for: categoryName)
        view?.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc private func hideKeyboard() {
        view?.endEditing(true)
    }
}

extension NewHabitViewController: ScheduleViewControllerDelegate {
    func didSelectSchedule(for days: [WeekDay]) {
        selectedDays = days
        habitOptionsTableView.reloadData()
        updateCreateButtonState()
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    // механика показа нотификации при превышении лимита символов в текстовом поле
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        // Вычисляем количество символов после изменения
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count > nameTextLimit {
            cautionLabel.isHidden = false
            return false
        } else {
            cautionLabel.isHidden = true
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        habitOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        if option == "Категория" {
            cell.detailTextLabel?.text = categoryName
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
        
        return cell
    }
}

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = habitOptions[indexPath.row]
        if option == "Категория" {
            print("Открыть стр категория")
        } else if option == "Расписание" {
            showScheduleViewController()
        }
    }
}
