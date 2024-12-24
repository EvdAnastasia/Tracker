//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Anastasiia on 01.12.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Public Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Private Properties
    private let cellWidth: CGFloat = 167
    private let cellHeight: CGFloat = 148
    
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
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
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
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.ypGray]
        let attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: attributes)
        textField.attributedPlaceholder = attributedPlaceholder
        return textField
    }()
    
    private lazy var noTrackersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StarIcon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var noTrackersLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
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
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: "TrackerCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        setupNavBar()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = plusButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        noTrackersImageView.translatesAutoresizingMaskIntoConstraints = false
        noTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        noTrackersStackView.translatesAutoresizingMaskIntoConstraints = false
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        view.addSubview(searchTextField)
        view.addSubview(noTrackersStackView)
        view.addSubview(trackersCollectionView)
        
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
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
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
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    // количество ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    // генерация ячеек
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as! TrackersCollectionViewCell
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    // нажатие на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    // размеры ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
