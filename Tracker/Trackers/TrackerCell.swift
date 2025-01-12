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

private enum Constants {
    static let colorBackgroundViewHeight: CGFloat = 90
    static let emojiBackgroundViewSize: CGFloat = 24
    static let padding: CGFloat = 12
    static let plusButtonSize: CGFloat = 34
    static let plusButtonPadding: CGFloat = 8
}

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - Private Properties
    private var trackerId: UUID?
    private var isCompletedToday: Bool = false
    private var indexPath: IndexPath?
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        isFutureTracker: Bool,
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
        
        if isFutureTracker {
            plusButton.isHidden = true
        } else {
            plusButton.isHidden = false
            let image = isCompletedToday ?
            UIImage(named: "DoneIcon")?.withRenderingMode(.alwaysTemplate) :
            UIImage(named: "PlusIcon")?.withRenderingMode(.alwaysTemplate)
            plusButton.setImage(image, for: .normal)
            plusButton.tintColor = color
            plusButton.alpha = isCompletedToday ?  0.3 : 1
        }
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
        [colorBackgroundView,
         emojiBackgroundView,
         nameLabel,
         counterStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        emojiBackgroundView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            colorBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorBackgroundView.heightAnchor.constraint(equalToConstant: Constants.colorBackgroundViewHeight),
            colorBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: Constants.emojiBackgroundViewSize),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: Constants.emojiBackgroundViewSize),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: colorBackgroundView.leadingAnchor, constant: Constants.padding),
            emojiBackgroundView.topAnchor.constraint(equalTo: colorBackgroundView.topAnchor, constant: Constants.padding),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: colorBackgroundView.leadingAnchor, constant: Constants.padding),
            nameLabel.trailingAnchor.constraint(equalTo: colorBackgroundView.trailingAnchor, constant: -Constants.padding),
            nameLabel.bottomAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor, constant: -Constants.padding),
            
            counterStackView.topAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor),
            counterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            counterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            
            plusButton.widthAnchor.constraint(equalToConstant: Constants.plusButtonSize),
            plusButton.heightAnchor.constraint(equalToConstant: Constants.plusButtonSize),
            plusButton.topAnchor.constraint(equalTo: counterStackView.topAnchor, constant: Constants.plusButtonPadding),
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
