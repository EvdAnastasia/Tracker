//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Anastasiia on 19.01.2025.
//

import UIKit
import CoreData

private enum TrackerRecordStoreError: Error {
    case decodingError
}

final class TrackerRecordStore {
    
    // MARK: - Public Properties
    static let shared = TrackerRecordStore()
    
    // MARK: - Private Properties
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func fetchRecords() -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let fetchedData = try? coreDataManager.context.fetch(request)
        
        guard let fetchedData else {
            return []
        }
        
        return fetchedData.compactMap {
            try? convertRecord(from: $0)
        }
    }
    
    func addRecord(_ record: TrackerRecord) {
        let trackerRecord = TrackerRecordCoreData(context: coreDataManager.context)
        
        trackerRecord.date = record.date
        trackerRecord.trackerId = record.trackerId
        coreDataManager.saveContext()
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: record.date)
        
        request.predicate = NSPredicate(format: "trackerId == %@ AND date == %@", record.trackerId as CVarArg, startOfDay as CVarArg)
        
        let fetchedData = try? coreDataManager.context.fetch(request)
        
        if let recordForDelete = fetchedData?.first {
            coreDataManager.context.delete(recordForDelete)
            coreDataManager.saveContext()
        }
    }
    
    // MARK: - Private Methods
    private func convertRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.trackerId,
              let date = trackerRecordCoreData.date else {
            throw TrackerRecordStoreError.decodingError
        }
        
        return TrackerRecord(trackerId: id, date: date)
    }
}
