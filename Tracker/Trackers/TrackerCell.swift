//
//  TrackerCell.swift
//  Tracker
//
//  Created by Anastasiia on 15.12.2024.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Private Properties
    private var trackerId: UUID?
    private var isCompletedToday: Bool = false
    private var indexPath: IndexPath?
    
    private let colorBackgroundViewHeight: CGFloat = 90
    private let emojiBackgroundViewSize: CGFloat = 24
    private let padding: CGFloat = 12
    private let plusButtonSize: CGFloat = 34
    private let plusButtonPadding: CGFloat = 8
    
    private lazy var colorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypColorSelection5
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGrayBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .ypWhite
        return label
    }()
    
    private lazy var сounterLabel: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(trackButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var counterStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [сounterLabel, plusButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - Overrides Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(
        with tracker: Tracker,
        isCompletedToday: Bool,
        completedDays: Int,
        indexPath: IndexPath
    ) {
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        
        let color = tracker.color
        colorBackgroundView.backgroundColor = color
        emojiLabel.text = tracker.emoji
        nameLabel.text = tracker.title
        
        let wordDay = pluralizeDays(completedDays)
        сounterLabel.text = "\(wordDay)"
        
        let image = isCompletedToday ?
        UIImage(named: "DoneIcon")?.withRenderingMode(.alwaysTemplate) :
        UIImage(named: "PlusIcon")?.withRenderingMode(.alwaysTemplate)
        plusButton.setImage(image, for: .normal)
        plusButton.tintColor = color
        plusButton.alpha = isCompletedToday ?  0.3 : 1
    }
    
    // MARK: - Private Methods
    private func pluralizeDays(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(count) день"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            return "\(count) дня"
        } else {
            return "\(count) дней"
        }
    }
    
    private func setupConstraints() {
        colorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        emojiBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        counterStackView.translatesAutoresizingMaskIntoConstraints = false
        сounterLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(colorBackgroundView)
        contentView.addSubview(emojiBackgroundView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(counterStackView)
        emojiBackgroundView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            colorBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorBackgroundView.heightAnchor.constraint(equalToConstant: colorBackgroundViewHeight),
            colorBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: emojiBackgroundViewSize),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: emojiBackgroundViewSize),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: colorBackgroundView.leadingAnchor, constant: padding),
            emojiBackgroundView.topAnchor.constraint(equalTo: colorBackgroundView.topAnchor, constant: padding),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: colorBackgroundView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: colorBackgroundView.trailingAnchor, constant: -padding),
            nameLabel.bottomAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor, constant: -padding),
            
            counterStackView.topAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor),
            counterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            counterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            plusButton.widthAnchor.constraint(equalToConstant: plusButtonSize),
            plusButton.heightAnchor.constraint(equalToConstant: plusButtonSize),
            plusButton.topAnchor.constraint(equalTo: counterStackView.topAnchor, constant: plusButtonPadding),
        ])
    }
    
    @objc private func trackButtonTapped() {
        guard let trackerId, let indexPath else {
            assertionFailure("No trackerId")
            return
        }
        
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
}
