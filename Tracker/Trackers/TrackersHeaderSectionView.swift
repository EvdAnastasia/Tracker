//
//  TrackersHeaderSection.swift
//  Tracker
//
//  Created by Anastasiia on 03.01.2025.
//

import UIKit

final class TrackersHeaderSection: UICollectionReusableView {
    
    // MARK: - Private Properties
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
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
    func configure(with text: String) {
        headerLabel.text = text
    }
    
    // MARK: - Private Methods
    private func setupConstraints() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
}
