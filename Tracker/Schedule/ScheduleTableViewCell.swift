//
//  ScheduleTableViewCell.swift
//  Tracker
//
//  Created by Anastasiia on 25.12.2024.
//

import UIKit

protocol ScheduleTableViewCellDelegate: AnyObject {
    func didChangeSwitchState(for index: Int, isOn: Bool)
}

final class ScheduleTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let reuseIdentifier = "ScheduleCell"
    weak var delegate: ScheduleTableViewCellDelegate?
    
    // MARK: - Private Properties
    private var index: Int?
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var daySwitchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .ypBlue
        switchControl.addTarget(self, action: #selector(switchControlChanged), for: .valueChanged)
        return switchControl
    }()
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    // MARK: - Public Methods
    func configureCell(dayName: String,
                       index: Int,
                       switchStatus: Bool
    ) {
        self.index = index
        dayLabel.text = dayName
        daySwitchControl.isOn = switchStatus
    }
    
    // MARK: - Private Methods
    private func setupCell() {
        contentView.backgroundColor = .ypLightGray
    }
    
    private func setupConstraints() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        daySwitchControl.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(daySwitchControl)
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            daySwitchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func switchControlChanged(_ sender: UISwitch) {
        guard let index else { return }
        delegate?.didChangeSwitchState(for: index, isOn: sender.isOn)
    }
}
