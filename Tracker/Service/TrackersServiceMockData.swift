//
//  TrackersServiceMockData.swift
//  Tracker
//
//  Created by Anastasiia on 13.01.2025.
//

import Foundation

enum TrackersServiceMockData {
    static let trackers: [TrackerCategory] = [
        TrackerCategory(
            title: "Уборка",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Помыть полы",
                    color: .ypColorSelection5,
                    emoji: "💦",
                    schedule: [.monday, .wednesday, .friday, .sunday],
                    isHabit: true
                ),
                Tracker(
                    id: UUID(),
                    title: "Протереть пыль",
                    color: .ypColorSelection8,
                    emoji: "💪",
                    schedule: [],
                    isHabit: false
                )
            ]
        ),
        TrackerCategory(
            title: "Работа",
            trackers: [
                Tracker(
                    id: UUID(),
                    title: "Сделать таску",
                    color: .ypColorSelection12,
                    emoji: "📝",
                    schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .sunday],
                    isHabit: true
                ),
                Tracker(
                    id: UUID(),
                    title: "Отправить ПР",
                    color: .ypColorSelection16,
                    emoji: "✅",
                    schedule: [.friday],
                    isHabit: true
                )
            ]
        ),
        TrackerCategory(title: "Важное", trackers: [])
    ]
}
