//
//  StyleCell.swift
//  Tracker
//
//  Created by Anastasiia on 14.01.2025.
//

import UIKit

final class StyleCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        return label
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = StyleCellConstants.cornerRadius
        return view
    }()
    
    // MARK: - Overrides Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configureEmojiCell(with emoji: String) {
        emojiLabel.text = emoji
    }
    
    func configureColorCell(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func selectEmojiCell(_ isSelected: Bool) {
        if isSelected {
            contentView.layer.cornerRadius = 16
            contentView.backgroundColor = .ypLightGray
            contentView.layer.masksToBounds = true
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
    func selectColorCell(isSelected: Bool, color: UIColor) {
        if isSelected {
            contentView.layer.cornerRadius = StyleCellConstants.cornerRadius
            contentView.layer.masksToBounds = true
            contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
            contentView.layer.borderWidth = 3
        } else {
            contentView.layer.borderColor = color.cgColor
        }
        
    }
    
    // MARK: - Private Methods
    private func configureView() {
        contentView.backgroundColor = .ypWhite
    }
    
    private func setupConstraints() {
        [emojiLabel,
         colorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            colorView.heightAnchor.constraint(equalToConstant: StyleCellConstants.colorSize),
            colorView.widthAnchor.constraint(equalToConstant: StyleCellConstants.colorSize),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
