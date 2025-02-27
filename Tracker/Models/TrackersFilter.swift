//
//  TrackersFilter.swift
//  Tracker
//
//  Created by Anastasiia on 26.02.2025.
//

import Foundation

enum TrackersFilter: CaseIterable {
    case all
    case forToday
    case completed
    case uncompleted

    var title: String {
        switch self {
        case .all:
            return "Все трекеры"
        case .forToday:
            return "Трекеры на сегодня"
        case .completed:
            return "Завершенные"
        case .uncompleted:
            return "Не завершенные"
        }
    }
}
