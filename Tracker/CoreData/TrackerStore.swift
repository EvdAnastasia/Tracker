//
//  TrackerStore.swift
//  Tracker
//
//  Created by Anastasiia on 19.01.2025.
//

import UIKit
import CoreData

private enum TrackerStoreError: Error {
    case decodingError
}

final class TrackerStore {
    
    // MARK: - Public Properties
    static let shared = TrackerStore()
    
    // MARK: - Private Properties
    private let coreDataManager = CoreDataManager.shared
    private let weekDaysConverter = WeekDaysConverter()
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func addTracker(_ tracker: Tracker, category: TrackerCategoryCoreData) {
        let trackerCoreData = TrackerCoreData(context: coreDataManager.context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.color = UIColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = weekDaysConverter.convertToString(from: tracker.schedule)
        trackerCoreData.isHabit = tracker.isHabit
        trackerCoreData.category = category
        
        coreDataManager.saveContext()
    }
    
    func convertTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
              let title = trackerCoreData.title,
              let color = trackerCoreData.color,
              let emoji = trackerCoreData.emoji,
              let schedule = trackerCoreData.schedule else {
            throw TrackerStoreError.decodingError
        }
        
        return Tracker(
            id: id,
            title: title,
            color: UIColorMarshalling.color(from: color),
            emoji: emoji,
            schedule: weekDaysConverter.convertToArray(from: schedule),
            isHabit: trackerCoreData.isHabit
        )
    }
}
