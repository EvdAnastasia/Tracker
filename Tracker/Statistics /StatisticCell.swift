//
//  StatisticCell.swift
//  Tracker
//
//  Created by Anastasiia on 27.02.2025.
//

import UIKit

final class StatisticCell: UITableViewCell {
    
    // MARK: - Private Properties
    private lazy var borderGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        let colorFirst = UIColor.ypColorSelection3.cgColor
        let colorSecond = UIColor.ypColorSelection9.cgColor
        let colorThird = UIColor.ypColorSelection1.cgColor
        layer.colors = [colorFirst, colorSecond, colorThird]
        layer.startPoint = .init(x: 0, y: 0.5)
        layer.endPoint = .init(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 16).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.lineWidth = 1
        layer.mask = shape
        
        self.clipsToBounds = true
        self.layer.addSublayer(layer)
        
        return layer
    }()
    
    private lazy var borderGradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        return label
    }()
    
    // MARK: - Overrides Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderGradient.frame = borderGradientView.bounds
        borderGradientView.layer.addSublayer(borderGradient)
    }
    
    // MARK: - Public Methods
    func configureCell(title: String, completedDays: Int) {
        numberLabel.text = "\(completedDays)"
        titleLabel.text = title
    }
    
    // MARK: - Private Methods
    private func setupCell() {
        contentView.backgroundColor = .ypWhite
        contentView.layer.cornerRadius = 16
        contentView.layer.borderColor = UIColor.black.cgColor
        selectionStyle = .none
        separatorInset = .zero
    }
    
    private func setupConstraints() {
        [borderGradientView,
         numberLabel,
         titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            borderGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderGradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderGradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            titleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: numberLabel.trailingAnchor)
            
        ])
    }
}
