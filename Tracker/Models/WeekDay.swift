//
//  WeekDay.swift
//  Tracker
//
//  Created by Anastasiia on 25.12.2024.
//

import Foundation

enum WeekDay: Int, CaseIterable {
    case monday = 1
    case tuersday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
    
    func getShortDayName() -> String {
        switch self {
        case .monday:
            "Пн"
        case .tuersday:
            "Вт"
        case .wednesday:
            "Ср"
        case .thursday:
            "Чт"
        case .friday:
            "Пт"
        case .saturday:
            "Сб"
        case .sunday:
            "Вс"
        }
    }
    
    func getFullDayName() -> String {
        switch self {
        case .monday:
            "Понедельник"
        case .tuersday:
            "Вторник"
        case .wednesday:
            "Среда"
        case .thursday:
            "Четверг"
        case .friday:
            "Пятница"
        case .saturday:
            "Суббота"
        case .sunday:
            "Воскресенье"
        }
    }
    
}
