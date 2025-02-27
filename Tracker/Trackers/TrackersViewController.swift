//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Anastasiia on 01.12.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    private let trackersService = TrackersService.shared
    private let userDefaultsService = UserDefaultsService.shared
    private var categories: [TrackerCategory] = []
    private var filteredСategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    private var trackersFilter = TrackersFilter.all
    
    private lazy var plusButton: UIBarButtonItem = {
        let addImage = UIImage(named: "AddIcon")
        let button = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(addNewTracker))
        button.tintColor = .ypBlack
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = .current
        picker.calendar.firstWeekday = 2
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 8
        picker.tintColor = .ypBlue
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        let labelText = NSLocalizedString("trackers", comment: "Label text")
        label.text = labelText
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.backgroundColor = .ypWhite
        textField.textColor = .ypBlack
        textField.font = .systemFont(ofSize: 17)
        textField.layer.cornerRadius = 10
        textField.delegate = self
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.ypGray]
        let placeholderText = NSLocalizedString("search", comment: "Placeholder text")
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        textField.addTarget(self, action: #selector(searchTextDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var noTrackersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StarIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var noTrackersLabel: UILabel = {
        let label = UILabel()
        let labelText = NSLocalizedString("emptyTrackers.title", comment: "Empty trackers label")
        label.text = labelText
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var noTrackersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noTrackersImageView, noTrackersLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.register(TrackersHeaderSection.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        collectionView.backgroundColor = .ypWhite
        collectionView.isScrollEnabled = true
        collectionView.bounces = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        let title = NSLocalizedString("filters", comment: "Filters label")
        let titleColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .white
        }
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = .ypBlue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return gesture
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        trackersService.delegate = self
        userDefaultsService.lastSelectedFilter = trackersFilter.title
        completedTrackers = trackersService.fetchRecords()
        reloadData()
        configureView()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func reloadData() {
        categories = trackersService.fetchCategories()
        dateChanged()
    }
    
    private func configureView() {
        view.backgroundColor = .ypWhite
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = plusButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func reloadFilteredCategories() {
        let calendar = Calendar.current
        let selectedWeekDay = calendar.component(.weekday, from: currentDate)
        let filterWeekday = selectedWeekDay == 1 ? 7 : selectedWeekDay - 1
        var pinnedTrackers: [Tracker] = []
        
        var newFilteredСategories = categories.compactMap { category in
            let trackers = filter(trackers: category.trackers, filterWeekday: filterWeekday)
            
            pinnedTrackers.append(contentsOf: trackers.filter { $0.isPinned })
            let nonPinnedTrackers = trackers.filter { !$0.isPinned }
            
            return nonPinnedTrackers.isEmpty ? nil : TrackerCategory(
                title: category.title,
                trackers: nonPinnedTrackers
            )
        }
        
        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(title: TrackersConstants.pinnedTitle, trackers: pinnedTrackers)
            newFilteredСategories.insert(pinnedCategory, at: 0)
        }
        
        filteredСategories = newFilteredСategories
        
        trackersCollectionView.reloadData()
        reloadNoTrackersView()
    }
    
    private func filter(trackers: [Tracker], filterWeekday: Int) -> [Tracker] {
        var searchFilteredData: [Tracker] = []
        var filteredData: [Tracker] = []
        
        // фильтрация по дате
        let dateFilteringTrackers = trackers.filter { tracker in
            tracker.schedule.contains { weekDay in weekDay.rawValue == filterWeekday} == true ||
            // нерегулярное событие показываем сегодня, если оно не было выполнено до этого
            (!tracker.isHabit &&
             Calendar.current.isDate(Date(), inSameDayAs: currentDate) &&
             completedTrackers.contains { $0.trackerId == tracker.id } == false) ||
            // или если было выполнено в этот день
            !tracker.isHabit && isTrackerCompletedToday(id: tracker.id)
        }
        
        // фильтрация по поиску
        if let searchText = searchTextField.text, !searchText.isEmpty {
            searchFilteredData = dateFilteringTrackers.filter { $0.title.lowercased().contains(searchText.lowercased())
            }
        } else {
            searchFilteredData = dateFilteringTrackers
        }
        
        // применение фильтра
        if trackersFilter == .completed {
            filteredData = searchFilteredData.filter { tracker in
                isTrackerCompletedToday(id: tracker.id)
            }
        } else {
            filteredData = searchFilteredData
        }
        
        if trackersFilter == .uncompleted {
            return filteredData.filter { tracker in
                !isTrackerCompletedToday(id: tracker.id)
            }
        } else {
            return filteredData
        }
        
    }
    
    private func reloadNoTrackersView() {
        let isAnyTracker = categories.contains { !$0.trackers.isEmpty }
        let isAnyFilteredTracker = filteredСategories.contains { !$0.trackers.isEmpty }
        
        if isAnyTracker && isAnyFilteredTracker {
            filterButton.isHidden = false
            trackersCollectionView.isHidden = false
            noTrackersStackView.isHidden = true
        } else {
            let image = isAnyTracker ? UIImage(named: "ErrorSmile") : UIImage(named: "StarIcon")
            let text = isAnyTracker ?
            NSLocalizedString("emptyFilteredTrackers.title", comment: "Empty filtered trackers label") :
            NSLocalizedString("emptyTrackers.title", comment: "Empty trackers label")
            
            filterButton.isHidden = true
            trackersCollectionView.isHidden = true
            noTrackersStackView.isHidden = false
            noTrackersImageView.image = image
            noTrackersLabel.text = text
        }
    }
    
    private func pinToggleButtonTapped(_ isPinned: Bool, for tracker: Tracker) {
        trackersService.togglePinTracker(isPinned, for: tracker)
    }
    
    private func editButtonTapped(for indexPath: IndexPath) {
        let tracker = filteredСategories[indexPath.section].trackers[indexPath.row]
        var titleCategory = filteredСategories[indexPath.section].title
        let isHabit = tracker.isHabit
        let completedDays = completedTrackers.filter { $0.trackerId == tracker.id }.count
        
        if tracker.isPinned && titleCategory == TrackersConstants.pinnedTitle {
            let category = trackersService.fetchCategory(by: tracker.id)
            guard let category, let title = category.title else { return }
            
            titleCategory = title
        }
        
        let newViewController = GenericEventViewController(
            eventType: isHabit ? .habitEditing : .irregularEditing,
            tracker: tracker,
            category: titleCategory,
            completedDays: completedDays
        )
        let newNavController = UINavigationController(rootViewController: newViewController)
        navigationController?.present(newNavController, animated: true)
    }
    
    private func deleteTracker(for indexPath: IndexPath) {
        var titleCategory = filteredСategories[indexPath.section].title
        let tracker = filteredСategories[indexPath.section].trackers[indexPath.row]
        
        if tracker.isPinned && titleCategory == TrackersConstants.pinnedTitle {
            let category = trackersService.fetchCategory(by: tracker.id)
            guard let category, let title = category.title else { return }
            
            titleCategory = title
        }
        
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let trackerRecord = TrackerRecord(trackerId: tracker.id, date: startOfDay)
        trackersService.deleteRecord(trackerRecord)
        
        trackersService.deleteTracker(tracker, for: titleCategory)
    }
    
    private func showDeleteConfirmationAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Уверены что хотите удалить трекер?",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.deleteTracker(for: indexPath)
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        [nameLabel,
         searchTextField,
         noTrackersStackView,
         trackersCollectionView,
         filterButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.addGestureRecognizer(tapGesture)
        
        trackersCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            noTrackersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTrackersStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 18),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func activateFilter(for filter: TrackersFilter) {
        switch filter {
        case .all:
            filterButton.titleLabel?.textColor = .white
        case .forToday:
            filterButton.titleLabel?.textColor = .white
        case .completed:
            filterButton.titleLabel?.textColor = .green
        case .uncompleted:
            filterButton.titleLabel?.textColor = .ypRed
        }
    }
    
    @objc private func addNewTracker() {
        let trackerTypeSelectingViewController = TrackerTypeSelectingViewController()
        let trackerTypeSelectingNavController = UINavigationController(rootViewController: trackerTypeSelectingViewController)
        navigationController?.present(trackerTypeSelectingNavController, animated: true)
    }
    
    @objc private func dateChanged() {
        currentDate = datePicker.date
        reloadFilteredCategories()
    }
    
    @objc func searchTextDidChange() {
        reloadFilteredCategories()
    }
    
    @objc func filterButtonTapped() {
        let filtersViewController = FiltersViewController()
        filtersViewController.delegate = self
        let filtersNavController = UINavigationController(rootViewController: filtersViewController)
        present(filtersNavController, animated: true)
    }
    
    @objc private func hideKeyboard() {
        view?.endEditing(true)
    }
}

extension TrackersViewController: TrackersServiceDelegate {
    func reloadTrackers() {
        reloadData()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    // количество секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filteredСategories.count
    }
    
    // заголовок секции
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "SectionHeader", for: indexPath) as? TrackersHeaderSection
        guard let header else { return UICollectionReusableView() }
        let titleCategory = filteredСategories[indexPath.section].title
        header.configure(with: titleCategory)
        return header
    }
    
    // количество ячеек
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let trackers = filteredСategories[section].trackers
        return trackers.count
    }
    
    // генерация ячеек
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let cellData = filteredСategories
        let tracker = cellData[indexPath.section].trackers[indexPath.row]
        
        cell.delegate = self
        
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        let completedDays = completedTrackers.filter { $0.trackerId == tracker.id }.count
        let isFutureTracker = currentDate > Date()
        cell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            isFutureTracker: isFutureTracker,
            completedDays: completedDays,
            indexPath: indexPath,
            isPinned: tracker.isPinned
        )
        
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: currentDate)
        return trackerRecord.trackerId == id && isSameDay
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    // размеры ячейки
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 9)/2, height: TrackerCellConstants.cellHeight)
    }
    
    // расстояние между ячейками
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 9
    }
    
    // высота заголовка секции
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 48)
    }
    
    // контекстное меню
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        guard let indexPath = indexPaths.first else { return nil }
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let tracker = self.filteredСategories[indexPath.section].trackers[indexPath.row]
            let isPinned = tracker.isPinned
            let pinToggleTitle = isPinned ? "Открепить" : "Закрепить"
            
            let pinToggleAction = UIAction(title: pinToggleTitle) { [weak self] _ in
                self?.pinToggleButtonTapped(!isPinned, for: tracker)
            }
            
            let editAction = UIAction(title: "Редактировать") { [weak self] _ in
                self?.editButtonTapped(for: indexPath)
            }
            
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                self?.showDeleteConfirmationAlert(for: indexPath)
            }
            
            return UIMenu(children: [pinToggleAction, editAction, deleteAction])
        }
        
        return configuration
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let trackerRecord = TrackerRecord(trackerId: id, date: startOfDay)
        
        trackersService.addRecord(trackerRecord)
        completedTrackers = trackersService.fetchRecords()
        trackersCollectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let trackerRecord = TrackerRecord(trackerId: id, date: startOfDay)
        
        trackersService.deleteRecord(trackerRecord)
        completedTrackers = trackersService.fetchRecords()
        trackersCollectionView.reloadItems(at: [indexPath])
    }
}

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TrackersViewController: FiltersViewControllerDelegate {
    func didSelectFilter(_ filter: TrackersFilter) {
        trackersFilter = filter
        activateFilter(for: filter)
        
        if trackersFilter == .forToday {
            currentDate = Date()
            datePicker.date = currentDate
        }
        
        reloadFilteredCategories()
    }
}
