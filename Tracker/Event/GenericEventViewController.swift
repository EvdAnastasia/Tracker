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
    private var selectedEmoji: Emoji?
    private var selectedColor: Color?
    private var selectedCategory: String?
    
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
    
    private lazy var habitStyleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            StyleCell.self,
            forCellWithReuseIdentifier: GenericEventConstants.styleCellReuseIdentifier
        )
        collectionView.register(
            StyleHeaderSection.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GenericEventConstants.styleHeaderReuseIdentifier
        )
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .ypWhite
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        configureUI()
        configureView()
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
        selectedCategory?.isEmpty == false &&
        (eventType == EventType.habit ? !selectedDays.isEmpty : true) &&
        selectedEmoji?.index != nil &&
        selectedColor?.index != nil
        
        createButton.backgroundColor = notEmpty ? .ypBlack : .ypGray
        createButton.isEnabled = notEmpty
    }
    
    private func calculateCollectionHeight() -> CGFloat {
        let headerHeight = GenericEventConstants.collectionViewHeaderHeight
        let cellSize = GenericEventConstants.collectionViewCellSize
        let rowCountForSection = GenericEventConstants.collectionViewRowCountForSection
        let inset = GenericEventConstants.collectionViewInsetLarge
        let sections = TrackerStyleSections.allCases.count
        
        let sectionHeight = headerHeight + (CGFloat(rowCountForSection) * cellSize) + inset * 2
        let collectionHeight = sectionHeight * CGFloat(sections)
        return collectionHeight
    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [nameFieldStackView,
         habitOptionsTableView,
         habitStyleCollectionView,
         buttonsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        view.addGestureRecognizer(tapGesture)
        
        let collectionViewHeight = calculateCollectionHeight()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameFieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameField.heightAnchor.constraint(equalToConstant: GenericEventConstants.nameFieldHeight),
            
            habitOptionsTableView.topAnchor.constraint(equalTo: nameFieldStackView.bottomAnchor, constant: 24),
            habitOptionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitOptionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            habitOptionsTableView.heightAnchor.constraint(equalToConstant: habitOptionsTableViewHeight),
            
            habitStyleCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            habitStyleCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            habitStyleCollectionView.topAnchor.constraint(equalTo: habitOptionsTableView.bottomAnchor, constant: 16),
            habitStyleCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: GenericEventConstants.buttonsStackViewHeight),
            buttonsStackView.topAnchor.constraint(equalTo: habitStyleCollectionView.bottomAnchor, constant: 16),
            buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func showCategoriesViewController() {
        let categoriesViewModel = CategoriesViewModel()
        let categoriesViewController = CategoriesViewController(
            viewModel: categoriesViewModel,
            selectedCategory: selectedCategory
        )
        categoriesViewController.delegate = self
        let categoriesNavController = UINavigationController(rootViewController: categoriesViewController)
        navigationController?.present(categoriesNavController, animated: true)
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
        guard let title = nameField.text,
        let category = selectedCategory,
        let emoji = selectedEmoji?.emoji,
        let color = selectedColor?.color else { return }
        
        let isHabit = eventType == EventType.habit
        let schedule = isHabit ? selectedDays : []
        
        let newTracker = Tracker(
            id: UUID(),
            title: title,
            color: color,
            emoji: emoji,
            schedule: schedule,
            isHabit: isHabit
        )
        
        trackersService.addTracker(newTracker, to: category)
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

extension GenericEventViewController: CategoriesViewControllerDelegate {
    func didSelectCategory(_ name: String) {
        selectedCategory = name
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
        
        if indexPath.row < habitOptions.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
            cell.detailTextLabel?.text = selectedCategory
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
            showCategoriesViewController()
        } else if option == "Расписание" {
            showScheduleViewController()
        }
    }
}

extension GenericEventViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        TrackerStyleSections.allCases.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let section = TrackerStyleSections(rawValue: section) else { return 0 }
        switch section {
        case .emoji:
            return GenericEventConstants.emoji.count
        case .colors:
            return GenericEventConstants.colors.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenericEventConstants.styleCellReuseIdentifier, for: indexPath) as? StyleCell else {
            return UICollectionViewCell()
        }
        
        if let section = TrackerStyleSections(rawValue: indexPath.section) {
            switch section {
            case .emoji:
                cell.configureEmojiCell(with: GenericEventConstants.emoji[indexPath.row])
            case .colors:
                cell.configureColorCell(with: GenericEventConstants.colors[indexPath.row])
            }
        }
        
        return cell
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GenericEventConstants.styleHeaderReuseIdentifier,
            for: indexPath) as? StyleHeaderSection
        guard let header else { return UICollectionReusableView()}
        
        let section = TrackerStyleSections(rawValue: indexPath.section)
        let title = section?.getHeaderName() ?? ""
        header.configureHeader(with: title)
        
        return header
    }
}

extension GenericEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: GenericEventConstants.collectionViewHeaderHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: GenericEventConstants.collectionViewCellSize,
            height: GenericEventConstants.collectionViewCellSize
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: GenericEventConstants.collectionViewInsetLarge,
            left: GenericEventConstants.collectionViewInset,
            bottom: GenericEventConstants.collectionViewInsetLarge,
            right: GenericEventConstants.collectionViewInset
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        GenericEventConstants.collectionViewCellSpacing
    }
}

extension GenericEventViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let section = TrackerStyleSections(rawValue: indexPath.section) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? StyleCell else { return }
        
        switch section {
        case .emoji:
            if selectedEmoji?.index == indexPath.item { return }
            
            if selectedEmoji?.index != nil {
                guard let prevIndex = selectedEmoji?.index else { return }
                guard let prevCell = collectionView.cellForItem(at: IndexPath(row: prevIndex, section: section.rawValue)) as? StyleCell else { return }
                prevCell.selectEmojiCell(false)
            }
            
            let index = indexPath.item
            let emoji = GenericEventConstants.emoji[indexPath.item]
            
            selectedEmoji = Emoji(index: index, emoji: emoji)
            cell.selectEmojiCell(true)
            
        case .colors:
            if selectedColor?.index == indexPath.item { return }
            
            if selectedColor?.index != nil {
                guard let prevIndex = selectedColor?.index else { return }
                guard let prevCell = collectionView.cellForItem(at: IndexPath(row: prevIndex, section: section.rawValue)) as? StyleCell else { return }
                prevCell.selectColorCell(isSelected: false, color: .clear)
            }
            
            let index = indexPath.item
            let color = GenericEventConstants.colors[indexPath.item]
            
            selectedColor = Color(index: index, color: color)
            cell.selectColorCell(isSelected: true, color: color)
        }
        
        updateCreateButtonState()
    }
}
