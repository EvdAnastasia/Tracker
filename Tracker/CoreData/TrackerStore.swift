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
    
    func updateTracker(_ tracker: Tracker, category: TrackerCategoryCoreData) -> TrackerCoreData? {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        let fetchedData = try? coreDataManager.context.fetch(request)
        if let trackerForUpdate = fetchedData?.first {
            trackerForUpdate.title = tracker.title
            trackerForUpdate.color = UIColorMarshalling.hexString(from: tracker.color)
            trackerForUpdate.emoji = tracker.emoji
            trackerForUpdate.schedule = weekDaysConverter.convertToString(from: tracker.schedule)
            trackerForUpdate.isHabit = tracker.isHabit
            trackerForUpdate.category = category
            
            coreDataManager.saveContext()
            
            return trackerForUpdate
        }
        
        return nil
    }
    
    func deleteTracker(_ tracker: Tracker, category: TrackerCategoryCoreData) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND category == %@", tracker.id as CVarArg, category as CVarArg)
        
        let fetchedData = try? coreDataManager.context.fetch(request)
        if let trackerForDelete = fetchedData?.first {
            coreDataManager.context.delete(trackerForDelete)
            coreDataManager.saveContext()
        }
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
