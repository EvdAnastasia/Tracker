//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Anastasiia on 15.12.2024.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
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
    
    private lazy var emoji: UILabel = {
        let label = UILabel()
        label.text = "❤️"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.text = "Бабушка прислала открытку в вотсапе"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .ypWhite
        return label
    }()
    
    private lazy var сounter: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "PlusIcon")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .ypColorSelection5
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var counterStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [сounter, plusButton])
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
    
    // MARK: - Private Methods
    private func setupConstraints() {
        colorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        emojiBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        emoji.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        counterStackView.translatesAutoresizingMaskIntoConstraints = false
        сounter.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(colorBackgroundView)
        contentView.addSubview(emojiBackgroundView)
        contentView.addSubview(name)
        contentView.addSubview(counterStackView)
        emojiBackgroundView.addSubview(emoji)
        
        NSLayoutConstraint.activate([
            colorBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorBackgroundView.heightAnchor.constraint(equalToConstant: colorBackgroundViewHeight),
            colorBackgroundView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: emojiBackgroundViewSize),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: emojiBackgroundViewSize),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: colorBackgroundView.leadingAnchor, constant: padding),
            emojiBackgroundView.topAnchor.constraint(equalTo: colorBackgroundView.topAnchor, constant: padding),
            
            emoji.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            name.leadingAnchor.constraint(equalTo: colorBackgroundView.leadingAnchor, constant: padding),
            name.trailingAnchor.constraint(equalTo: colorBackgroundView.trailingAnchor, constant: -padding),
            name.bottomAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor, constant: -padding),
            
            counterStackView.topAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor),
            counterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            counterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            plusButton.widthAnchor.constraint(equalToConstant: plusButtonSize),
            plusButton.heightAnchor.constraint(equalToConstant: plusButtonSize),
            plusButton.topAnchor.constraint(equalTo: counterStackView.topAnchor, constant: plusButtonPadding),
        ])
    }
    
    @objc private func plusButtonTapped() {
        print("plusButton tapped")
    }
}
