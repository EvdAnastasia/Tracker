//
//  TrackersService.swift
//  Tracker
//
//  Created by Anastasiia on 04.01.2025.
//

import Foundation

protocol TrackersServiceDelegate: AnyObject {
    func reloadTrackers()
}

private enum MockData {
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
                    schedule: [.monday, .tuersday, .wednesday, .thursday, .friday, .sunday],
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

final class TrackersService {
    
    // MARK: - Public Properties
    static let shared = TrackersService()
    weak var delegate: TrackersServiceDelegate?
    var trackers: [TrackerCategory] = MockData.trackers
    
    // MARK: - Initializers
    private init() { }
    
    // MARK: - Public Methods
    func addTracker(tracker: Tracker, for category: String) {
        if let categoryIndex = trackers.firstIndex(where: { $0.title == category }) {
            let currentCategory = trackers[categoryIndex]
            let newCategory = TrackerCategory(title: currentCategory.title,
                                              trackers: currentCategory.trackers + [tracker])
            
            trackers[categoryIndex] = newCategory
        }
        
        delegate?.reloadTrackers()
    }
}
