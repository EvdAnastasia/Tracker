//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Anastasiia on 15.12.2024.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
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
            colorBackgroundView.heightAnchor.constraint(equalToConstant: 90),
            colorBackgroundView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: colorBackgroundView.leadingAnchor, constant: 12),
            emojiBackgroundView.topAnchor.constraint(equalTo: colorBackgroundView.topAnchor, constant: 12),
            
            emoji.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emoji.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            name.leadingAnchor.constraint(equalTo: colorBackgroundView.leadingAnchor, constant: 12),
            name.trailingAnchor.constraint(equalTo: colorBackgroundView.trailingAnchor, constant: -12),
            name.bottomAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor, constant: -12),
            
            counterStackView.topAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor),
            counterStackView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            counterStackView.topAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor),
            counterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            plusButton.topAnchor.constraint(equalTo: counterStackView.topAnchor, constant: 8),
        ])
    }
    
    @objc private func plusButtonTapped() {
        print("plusButton tapped")
    }
}
