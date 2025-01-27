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
    private var categories: [TrackerCategory] = []
    private var filteredСategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var currentDate: Date = Date()
    
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
        picker.locale = Locale(identifier: "ru_RU")
        picker.calendar.firstWeekday = 2
        picker.clipsToBounds = true
        picker.layer.cornerRadius = 8
        picker.tintColor = .ypBlue
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.backgroundColor = .white
        textField.textColor = .ypBlack
        textField.font = .systemFont(ofSize: 17)
        textField.layer.cornerRadius = 10
        textField.delegate = self
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.ypGray]
        let attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
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
        label.text = "Что будем отслеживать?"
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
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        return gesture
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        trackersService.delegate = self
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
        
        filteredСategories = categories.compactMap { category in
            let trackers = filter(trackers: category.trackers, filterWeekday: filterWeekday)
            
            guard !trackers.isEmpty else { return nil }
            return TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
        
        trackersCollectionView.reloadData()
        reloadNoTrackersView()
    }
    
    private func filter(trackers: [Tracker], filterWeekday: Int) -> [Tracker] {
        trackers.filter { tracker in
            tracker.schedule.contains { weekDay in weekDay.rawValue == filterWeekday} == true ||
            // нерегулярное событие показываем сегодня, если оно не было выполнено до этого
            (!tracker.isHabit &&
             Calendar.current.isDate(Date(), inSameDayAs: currentDate) &&
             completedTrackers.contains { $0.trackerId == tracker.id } == false) ||
            // или если было выполнено в этот день
            !tracker.isHabit && isTrackerCompletedToday(id: tracker.id)
        }
    }
    
    private func reloadNoTrackersView() {
        noTrackersStackView.isHidden = !categories.isEmpty
        trackersCollectionView.isHidden = categories.isEmpty
    }
    
    private func setupConstraints() {
        [nameLabel,
         searchTextField,
         noTrackersStackView,
         trackersCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.addGestureRecognizer(tapGesture)
        
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
        ])
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
            indexPath: indexPath
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
